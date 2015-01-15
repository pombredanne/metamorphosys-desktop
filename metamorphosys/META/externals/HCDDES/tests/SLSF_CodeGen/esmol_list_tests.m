%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NOTE:                                            %%
%% This file was initially auto-generated by        %%
%% ./esmol_update_tests.sh                          %%
%%                                                  %%
%% The list of available tests may be regenerated   %%
%% by executing that script again from cygwin.      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = esmol_list_tests()
	result = {
		'abstest.mdl', 'unit/prims/abstest'
		'assignmenttest.mdl', 'unit/prims/assignment'
		'busobject.mdl', 'unit/prims/busobject'
		'busselector.mdl', 'unit/prims/busselector'
		'constant.mdl', 'unit/prims/constant'
		'constantMask.mdl', 'unit/prims/constant'
		'demux.mdl', 'unit/prims/demux/basic_demux'
		'demux_vector_conv.mdl', 'unit/prims/demux/demux_vector_conv'
		'DiscreteStateSpace.mdl', 'unit/prims/DiscreteStateSpace'
		'discretezeropole.mdl', 'unit/prims/discretezeropole'
		'dotproduct.mdl', 'unit/prims/dotproduct'
		'embedded.mdl', 'unit/prims/embedded/simple_embedded'
		'embedded_func_in_cond.mdl', 'unit/prims/embedded/embedded_func_in_cond'
		'embedded_persistent.mdl', 'unit/prims/embedded/embedded_persistent'
		'embedded_scope.mdl', 'unit/prims/embedded/embedded_scope'
		'embedded_transpose.mdl', 'unit/prims/embedded/embedded_transpose'
		'embedded_with_delay.mdl', 'unit/prims/embedded/embedded_with_delay'
		'embedded_with_end.mdl', 'unit/prims/embedded/embedded_with_end'
		'embedded_with_for_and_eps.mdl', 'unit/prims/embedded/embedded_with_for_and_eps'
		'embedded_with_reshape.mdl', 'unit/prims/embedded/embedded_with_reshape'
		'embedded_with_return.mdl', 'unit/prims/embedded/embedded_with_return'
		'embedded_with_structure.mdl', 'unit/prims/embedded/embedded_with_structure'
		'embedded_with_transpose.mdl', 'unit/prims/embedded/embedded_with_transpose'
		'embedded_zeros.mdl', 'unit/prims/embedded/embedded_zeros'
		'fcn.mdl', 'unit/prims/embedded/fcn'
		'gain.mdl', 'unit/prims/gain'
		'genericStructBusObject.mdl', 'unit/prims/genericStructBusObject'
		'ground.mdl', 'unit/prims/ground'
		'iftest.mdl', 'unit/prims/iftest'
		'logic.mdl', 'unit/prims/logic'
		'lookuptable1D.mdl', 'unit/prims/lookuptable/lookuptable1D'
		'lookuptable2D.mdl', 'unit/prims/lookuptable/lookuptable2D'
		'lookuptable3D.mdl', 'unit/prims/lookuptable/lookuptable3D'
		'math.mdl', 'unit/prims/math'
		'mfiletest.mdl', 'unit/prims/mfile'
		'math_reciprocal.mdl', 'unit/prims/math'
		'math_rem_mod.mdl', 'unit/prims/math'
		'minmax_basic.mdl', 'unit/prims/minmax'
		'multiportswitch_basic.mdl', 'unit/prims/multiportswitch'
		'mux.mdl', 'unit/prims/mux'
		'product.mdl', 'unit/prims/product'
		'relationalop.mdl', 'unit/prims/relationalop'
		'roundingtest.mdl', 'unit/prims/rounding'
		'saturate.mdl', 'unit/prims/saturate'
		'selector2D.mdl', 'unit/prims/Selector'
		'sf_data_store_memory.mdl', 'unit/prims/SF_data_store_memory'
		'sign.mdl', 'unit/prims/signum'
		'sqrttest.mdl', 'unit/prims/sqrttest'
		'subsystem_onedatasource_twooutputs.mdl', 'unit/prims/subsystem'
		'sum.mdl', 'unit/prims/sum'
		'switch_basic.mdl', 'unit/prims/switch'
		'switchcase.mdl', 'unit/prims/switchcase'
		'tofrom.mdl', 'unit/prims/tofrom'
		'toworkspace.mdl', 'unit/prims/toworkspace'
		'trig.mdl', 'unit/prims/trig'
		'unitdelay.mdl', 'unit/prims/unitdelay'
		'zeroorderhold.mdl', 'unit/prims/zeroorderhold'
		'zt.mdl', 'unit/prims/zt'
		'emptysubsystem.mdl', 'unit/regression/emptysubsystem'
		'init_custom_mask.mdl', 'unit/regression/InitMask'
		'instancemerge.mdl', 'unit/regression/instancemerge'
		'localtofrom.mdl', 'unit/regression/localtofrom'
		'matrixinv.mdl', 'unit/regression/matrixinv'
		'modelReferenceTest.mdl', 'unit/regression/ModelReferenceTest'
        'polymorphism.mdl', 'unit/regression/polymorphism'
		'subloops.mdl', 'unit/regression/subloops'
		'submux.mdl', 'unit/regression/submux'
		'truncate.mdl', 'unit/regression/truncate'
		'twelve_oclock.mdl', 'unit/stateflow/12oclock'
		'actions.mdl', 'unit/stateflow/actions'
		'and_state_interleavings_1_2.mdl', 'unit/stateflow/and_state_interleavings'
		'and_state_interleavings_2_1.mdl', 'unit/stateflow/and_state_interleavings'
		'c_syntax.mdl', 'unit/stateflow/c_syntax'
        'indexBase.mdl', 'unit/stateflow/indexBase'
		'language.mdl', 'unit/stateflow/language'
		'test_counter.mdl', 'unit/stateflow/counter'
		'dont_enter_at_initialization.mdl', 'unit/stateflow/dont_enter_at_initialization'
        'noTopLevelStates.mdl', 'unit/stateflow/NoTopLevelStates'
		'user_spec_exec_order.mdl', 'unit/stateflow/user_spec_exec_order'
		'embedded_function.mdl', 'unit/stateflow/function/embedded_function'
		'graphical_function.mdl', 'unit/stateflow/function/graphical_function'
		'truthtable.mdl', 'unit/stateflow/function/truthtable'
		'loops.mdl', 'unit/stateflow/loops'
	};
end