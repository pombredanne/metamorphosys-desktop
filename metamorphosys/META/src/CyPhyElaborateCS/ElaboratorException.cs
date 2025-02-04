﻿namespace CyPhyElaborateCS
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// Represents errors that occur during elaborating the model.
    /// </summary>
    [Serializable]
    public class ElaboratorException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ElaboratorException"/> class.
        /// </summary>
        public ElaboratorException()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ElaboratorException"/> class with a specified
        /// error message.
        /// </summary>
        /// <param name="message">The message that describes the error.</param>
        public ElaboratorException(string message)
            : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ElaboratorException"/> class with a specified
        /// error message and a reference to the inner exception that is the cause of
        /// this exception.
        /// </summary>
        /// <param name="message">The error message that explains the reason for the exception.</param>
        /// <param name="inner">The exception that is the cause of the current exception, or a null reference
        /// (Nothing in Visual Basic) if no inner exception is specified.</param>
        public ElaboratorException(string message, Exception inner)
            : base(message, inner)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ElaboratorException"/> class with serialized
        /// data.
        /// </summary>
        /// <param name="info">The System.Runtime.Serialization.SerializationInfo that holds the serialized
        /// object data about the exception being thrown.</param>
        /// <param name="context">The System.Runtime.Serialization.StreamingContext that contains contextual
        /// information about the source or destination.</param>
        protected ElaboratorException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context)
            : base(info, context)
        {
        }
    }
}
