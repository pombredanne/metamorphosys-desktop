
#ifndef FRAMED_EDIT_H
#define FRAMED_EDIT_H

#include <string>
#include <cassert>
#include <vector>
#include <cstdio>
#include <boost/asio.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/cstdint.hpp>
#include <boost/crc.hpp> 
#include <log4cpp/Category.hh>

using boost::uint8_t;
using boost::uint32_t;

namespace meta = edu::vanderbilt::isis::meta;

namespace isis {
	typedef std::vector<uint8_t> data_buffer;

	/**
	 * A generic function to show contents of a container holding byte data
	 * as a string with hex representation for each byte.
	 */
	template <class CharContainer>
	std::string show_hex(const CharContainer& container) {
		std::ostringstream formatter; 
		typename CharContainer::const_iterator ci;
		for (ci = container.begin(); ci != container.end(); ++ci) {
			formatter << std::hex << static_cast<int>(*ci);
		}
		return formatter.str();
	}

	/**
	 * The header size for framed messages
	 */
	const unsigned HEADER_SIZE = 20;

	/**
	 * A FamedMessage implements simple "packing" of protocol buffers Messages into
	 * a string prepended by a header specifying at least the payload length.
	 * MessageType should be a Message class generated by the protobuf compiler.
	 */
	// template <class MessageType>
	class FramedEdit
	{
	public:
		typedef boost::shared_ptr<meta::Edit> EditPointer;

		FramedEdit(EditPointer edit = EditPointer()) :
			m_logcat( ::log4cpp::Category::getInstance(std::string("metalink.framer")) ),
			m_edit(edit)
		{
			m_logcat.infoStream() << "framing request";
		}

		void set_load(EditPointer edit)
		{
			m_edit = edit;
		}

		EditPointer get_load()
		{
			return m_edit;
		}

		/**
		 *
		 * Pack the message into the given data_buffer.
		 * The buffer is resized to exactly fit the message.
		 * Return false in case of an error, true if successful.
	*/
		bool pack(data_buffer& buf) const
		{
			if (!m_edit)
				return false;

			const unsigned msg_size = m_edit->ByteSize();
			buf.resize(HEADER_SIZE + msg_size + 4);

			/**
			 * Encodes the payload supplied into a header at the beginning of buf
			*/
			m_edit->SerializeToArray(&buf[HEADER_SIZE], msg_size);

			unsigned ix = 0;
            buf[0] = magic[0];
			buf[1] = magic[1];
			buf[2] = magic[2];
			buf[3] = magic[3];

			pack(buf, 4, (uint32_t)msg_size);

			// error
			buf[8] = (uint8_t)0;
		    // priority
			buf[9] = (uint8_t)0;
			// reserved
			buf[10] = (uint8_t)0;
			buf[11] = (uint8_t)0xFF;

			// payload checksum
			boost::crc_32_type  crc_payload;
            crc_payload.process_bytes( &buf[HEADER_SIZE], msg_size );
			pack(buf, 12, crc_payload);
			pack(buf, HEADER_SIZE + msg_size, crc_payload);

			 // header checksum
			 boost::crc_32_type  crc_header;
             crc_header.process_bytes( &buf[0], HEADER_SIZE - 4 );
			 pack(buf, 16, crc_header);

			 return true;
		}

		/**
		 * Given a buffer with the first HEADER_SIZE bytes representing the header,
		 * decode the header and return the message length.
		 * <p>
		 * <table>
		 * <tr><th>size (bytes)</th><th>encoding</th><th>purpose</th></tr>
		 * <tr><td>4</td><td>0xdeadbeef</td><td>magic indicates start of frame </td></tr>
		 * <tr><td>4</td><td>big endian 32 bit integer, bytes</td><td>size of the load</td></tr>
		 * <tr><td>1</td><td>error code</td><td>error</td></tr>
		 * <tr><td>1</td><td>8 bit integer, higher is greater</td><td>priority</td></tr>
		 * <tr><td>2</td><td>bits</td><td>reserved</td></tr>
		 * <tr><td>4</td><td>crc32 checksum</td><td>load validation</td></tr>
		 * <tr><td>4</td><td>crc32 checksum</td><td>header validation (previous 16 bytes)</td></tr>
		 * <tr><td>(size of the load)</td><td>protocol buffer bytes</td><td>load</td></tr>
		 * <tr><td>4</td><td>crc32 checksum</td><td>load validation (repeated)</td></tr>
		 * </table>
		 *
		 * Rough procedure...
		 * <ol>
		 * <li>Check to make sure there are at least the minimum nuber of bytes</li>
		 * <li>Look for the magic</li>
		 * <li>Extract the load length</li>
		 * </ol>
		 * Return 0 in case of an error.
		 */
		unsigned decode_header() {
			m_input_start = 0;
			m_input_length = 0;
			unsigned last_relevant_position = m_input_buffer.size() - sizeof(magic) + 1;
			for (unsigned ix = 0; ix < last_relevant_position; ++ix) {
				if (m_input_buffer[ix] != magic[0]) {
					continue;
				}
				if (m_input_buffer.size() < m_input_start + HEADER_SIZE) {
					m_logcat.debugStream() << "not enough bytes to contain a header " << m_input_buffer.size();
					return 0;
				}
				m_input_start = ix;
  				++ix;
				if (m_input_buffer[ix] != magic[1]) {
						continue;
				}
				++ix;
				if (m_input_buffer[ix] != magic[2]) {	
					continue;
				}
				++ix;
				if (m_input_buffer[ix] != magic[3]) {	
					continue;
				}
				++ix;
				unsigned jx = ix;
				/* read the load length in network order */
				m_input_length = unpackUint32(m_input_buffer, jx);
			
				/* scik some stuff */
				jx += 1 + 1 + 2;

				uint32_t load_checksum = unpackChecksum(m_input_buffer, jx);
				uint32_t header_checksum = unpackChecksum(m_input_buffer, jx);
				/* TODO validate the header against its checksum */

				return m_input_length;
			}
			return 0;
		}

		void resize_input_buffer_for_header() {
			m_input_buffer.resize(HEADER_SIZE);
		}

		void resize_input_buffer_for_load() {
			m_input_buffer.resize(m_input_start + HEADER_SIZE + m_input_length + 4);
		}

		data_buffer get_input_buffer() {
			return m_input_buffer;
		}
	
		boost::asio::mutable_buffers_1 get_input_buffer_for_header() {
			return boost::asio::buffer(m_input_buffer);
		}

		boost::asio::mutable_buffers_1 get_input_buffer_for_payload() { 
			return boost::asio::buffer(&m_input_buffer[m_input_start + HEADER_SIZE], m_input_length + 4);
		}

		std::string show_input_buffer() {
			return show_hex(m_input_buffer);
		}
	
		/**
		 * Unpack and store a message from the given packed buffer.
		 * Return true if unpacking successful, false otherwise.
		 */
		bool unpack() {
			unsigned payload_start = m_input_start + HEADER_SIZE;
			return m_edit->ParseFromArray(&m_input_buffer[payload_start], m_input_length);
		}

	private:
		 ::log4cpp::Category& m_logcat;  

		 static uint8_t const magic[4];

		 unsigned m_input_start;
		 unsigned m_input_length;
		 data_buffer m_input_buffer;

		 unsigned m_output_start;
		 unsigned m_output__length;
		 data_buffer m_output_buffer;

		 EditPointer m_edit;

		/**
		 * unpack an integer in network order 
		 * buf is the vector from which the data is to be unpacked.
		 * ix is the starting position from which to unpack.
		 * The unpacked value is returned.
		 */
		uint32_t unpackUint32(const data_buffer& buf,  unsigned& ix) const {
				uint32_t value = 0;
				for (unsigned hx=0; hx < sizeof(value); ++hx, ++ix) {
					  value = value * 256 + (static_cast<unsigned>(buf[ix]) & 0x0FF);
				}
				return value;
		}

		/**
		 * unpack a checksum
		 */
		uint32_t unpackChecksum(const data_buffer& buf,  unsigned& ix) const {
			boost::crc_32_type result;
			for (unsigned hx=0; hx < sizeof(uint32_t); ++hx, ++ix) {
				result.process_byte(buf[hx]);
			}
			return result.checksum();
		}

		
	    /**
		 * pack an integer in network order 
		 */
		 unsigned pack( data_buffer& buf, const unsigned ix, const uint32_t value) const {		   
			    uint32_t wip = value;
				int jx = ix;
				for (unsigned hx=4; hx > 0 ; --hx, ++jx) {
					uint32_t byte =  (wip & 0x0FF);
					buf[ix+hx-1] = (uint8_t) byte;
					wip >>= 8;
				}
				return jx;
		}

		unsigned pack( data_buffer& buf,  const unsigned ix, const boost::crc_32_type value) const {
			const uint32_t wip = value.checksum();
			return pack(buf, ix, wip);
		}

	
	};

} // namespace isis

#endif /* FRAMED_EDIT_H */
