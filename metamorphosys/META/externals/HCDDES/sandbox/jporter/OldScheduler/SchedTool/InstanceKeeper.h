#ifndef _INSTANCE_KEEPER_H
#define _INSTANCE_KEEPER_H

#include <sstream>
#include <vector>
#include <map>

// TODO:  Create a class which holds the index relations -- make the actual constraint
// TODO:   solver classes hold a pointer to it, and copy it correctly (so we're not duplicating
// TODO:   the whole lookup table for every branch).

typedef struct {
public:
	unsigned int xvar;
	unsigned int yvar;
	int offset;
	int group;
}  LinearRelation;

typedef struct {
	unsigned int xvar;
	int duration;
} DurativeVariable;

typedef struct {
	unsigned int latvar;
	unsigned int sendervar;
	unsigned int rcvrvar;
	int maxdist;
} LatencyBound;

class InstanceKeeper
{
public:
	InstanceKeeper() : _lastidx(0), _last_lat_idx(0), _linear_constraints(0), 
		_serial_constraints(0), _duration_constraints(0), _latency_constraints(0), _linear_groups(0) { }
	virtual ~InstanceKeeper() { }

	unsigned int AddVar( std::string & name ) { _inst_varmap[name] = _lastidx; _var_instmap[_lastidx]=name; return _lastidx++; }
	unsigned int FindNum( std::string & name ) { return _inst_varmap[name]; }
	bool FindName( unsigned int num, std::string & name );
	bool FindLatencies( unsigned int num, std::vector< LatencyBound > & vlb );
	unsigned int NumVars() { return _lastidx; }
	unsigned int NumLatencies() { return (unsigned int) _Latencies.size(); }

	void SetHyperperiod( unsigned long long hp ) { _hyperperiod = hp; }
	unsigned long long GetHyperperiod() { return _hyperperiod; }

	// Outer interface for solver adapter -- returns false if instname is not found in map
	bool SerializeInstances( std::vector< std::string > & instnames, std::vector< unsigned long long > & instsizes );
	bool OrderInstances( std::vector< std::string > & instnames, unsigned long long dist, unsigned long long dur, bool strict = true );
	bool AddLatencyBound( std::vector< std::string > & sndrnames, std::vector< std::string > & rcvrname, unsigned long long maxdist );
	unsigned long long GetResult( std::string & name ) { return _var_valmap[ _inst_varmap[name] ]; }	

	// Inner interface for CP engine -- returns false if we have run out of the requested item
	bool GetNextEqualityPair( LinearRelation & lrel, bool reset = false );
	bool GetNextInequalityPair( LinearRelation & lrel, bool reset = false );
	bool GetNextDuration( DurativeVariable & dv, bool reset = false );
	bool GetNextSerialization( std::vector< DurativeVariable > & vdv, bool reset = false );
	bool GetNextLatencyBound( std::vector< LatencyBound > & lb, bool reset = false );
	void SetResult( unsigned int var, unsigned long long val ) { _var_valmap[ var ] = val; }

	unsigned long long GetNumSerializations() { return _serial_constraints; }
	unsigned long long GetNumLinearRelations() { return _linear_constraints; }
	unsigned long long GetNumLinearGroups() { return _linear_groups; }
	unsigned long long GetNumDurations() { return _duration_constraints; }
	unsigned long long GetNumLatencies() { return _latency_constraints; }
	std::string getLinearConstraint( unsigned long var ) { return _lin_cstr_desc[var]; }
	std::string getLinearGroup( unsigned long var ) { return _lin_grp_desc[var]; }
	void SaveConstraintResult(std::string & desc) { _dbg_results.push_back(desc); }
	std::vector< std::string > & GetDebugResults() { return _dbg_results; }

private:
	void SaveLinearConstraint( unsigned long var, std::string & desc ) { _lin_cstr_desc[var] = desc; }
	void SaveSerialConstraint( unsigned long var, std::string & desc ) { _ser_cstr_desc[var] = desc; }
	void SaveDurConstraint( unsigned long var, std::string & desc ) { _dur_cstr_desc[var] = desc; }
	void SaveLatConstraint( unsigned long var, std::string & desc ) { _lat_cstr_desc[var] = desc; }

	std::string printIneq( LinearRelation & lrel );
	std::string printEq( LinearRelation & lrel );
	std::string printDur( DurativeVariable & dv );
	std::string printSer( std::vector< DurativeVariable > & vdv );
	std::string printLat( std::vector< LatencyBound > & vlb );

	std::string printOrderedInstances( std::vector< std::string > & instnames, unsigned long long dist, unsigned long long dur, bool strict);
	std::string printSerializedInstances( std::vector< std::string > & instnames, std::vector< unsigned long long > & instsizes );
	std::string printLatencyBound( std::vector< std::string > & sndrnames, std::vector< std::string > & rcvrname, unsigned long long maxdist );

	std::map< std::string, unsigned int > _inst_varmap;
	std::map< unsigned int, std::string > _var_instmap;
	std::map< unsigned int, unsigned long long > _var_valmap;

	unsigned int _lastidx;
	unsigned int _last_lat_idx;

	unsigned long long _hyperperiod;

	std::vector< LinearRelation > _EqualityPairs;
	std::vector< LinearRelation > _InequalityPairs;
	std::vector< DurativeVariable > _Durations;
	std::vector< std::vector< DurativeVariable > > _Serializations;
	std::vector< std::vector< LatencyBound > > _Latencies;

	std::vector< LinearRelation >::iterator _pEqPairs;
	std::vector< LinearRelation >::iterator _pIeqPairs;
	std::vector< DurativeVariable >::iterator _pDurations;
	std::vector< std::vector< DurativeVariable > >::iterator _pSerializations;
	std::vector< std::vector< LatencyBound > >::iterator _pLatencies;

	std::map< unsigned long, std::string > _lin_cstr_desc;
	std::map< unsigned long, std::string > _lin_grp_desc;
	std::map< unsigned long, std::string > _ser_cstr_desc;
	std::map< unsigned long, std::string > _dur_cstr_desc;
	std::map< unsigned long, std::string > _lat_cstr_desc;
	std::vector< std::string > _dbg_results;

	unsigned long long _linear_constraints;
	unsigned long long _serial_constraints;
	unsigned long long _duration_constraints;
	unsigned long long _latency_constraints;
	unsigned long long _linear_groups; // Group bunches of constraints
};

#endif // _INSTANCE_KEEPER_H