Resolution {{RESOLUTION}}

{{#HOST_SECTION}}Proc {{NODENAME}} {{NODEFREQ}} {{SENDOHD}} {{RECVOHD}}
{{#TASK_SECTION}}Comp {{TASKNAME}} ={{FREQUENCY}} {{WCEXECTIME}} {{#OFFSET_SECTION}}Offset {{OFFSETTIME}}{{/OFFSET_SECTION}}
{{/TASK_SECTION}}{{#LOCAL_MSG_SECTION}}Msg {{MSGNAME}} {{MSGSIZE}} {{SENDTASK}} {{RECVTASKS}}
{{/LOCAL_MSG_SECTION}}
{{/HOST_SECTION}}
{{#BUS_SECTION}}Bus {{BUSNAME}} {{BUSRATE}} {{SETUPTIME}} {{#BUS_HOST_SECTION}}{{NODENAME}} {{/BUS_HOST_SECTION}}
{{#TT_SECTION}}{{/TT_SECTION}}{{#MSG_SECTION}}Msg {{MSGNAME}} {{MSGSIZE}} {{SENDTASK}} {{RECVTASKS}} {{#OFFSET_SECTION}}Offset {{OFFSETTIME}}{{/OFFSET_SECTION}}
{{/MSG_SECTION}}
{{/BUS_SECTION}}
{{#LATENCY_SECTION}}Latency {{LATENCY}} {{SENDTASK}} {{RECVTASK}}
{{/LATENCY_SECTION}}

