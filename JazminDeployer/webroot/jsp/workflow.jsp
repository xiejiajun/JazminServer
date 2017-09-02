<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Workflow Editor</title>
    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/linker.css">
    <link rel="stylesheet" href="/css/workflow.css">
    <style>
        #editor {
            border: solid 1px #cdcdcd;
        }
    </style>
</head>
<body>
<div id="bpms" class="bpms">
    <div id="linker"></div>
    <div id="run-status-dialog" class="run-status-dialog hidden">
        <div class="instance-info">
            <b>InstanceId:</b>
            <span id="instance-id" style="padding: 0 5px"></span>
            <span id="instance-state" class="state"></span>
            <div class="btn btn-default btn-xs btn-halt">Halt</div>
        </div>
        <div class="instance-token-nodes">
            <b>TokenNodes:</b><span id="instance-token-nodes"></span>
        </div>
        <div class="instance-variables">
            <table class="table">
                <thead>
                <th>Key</th>
                <th>Value</th>
                </thead>
                <tbody id="instance-variables">
                </tbody>
            </table>
        </div>
    </div>
    <div id="top" class="top">
        <div id="show-left" class="show-left">
            <div class="btn btn-default btn-xs text-center">&rang;</div>
        </div>
        <div id="show-right" class="show-right">
            <div class="btn btn-default btn-xs text-center">&lang;</div>
        </div>
        <div id="btn-groups" class="group">
            <div class="btn btn-default btn-sm btn-create">New</div>
            <div class="btn btn-default btn-sm btn-save ml-10 disabled">Save</div>
            <div class="btn btn-default btn-sm btn-run ml-10">Start</div>
            <div class="btn btn-default btn-sm btn-zoomin ml-10">ZoomIn</div>
            <div class="btn btn-default btn-sm btn-zoomout ml-10">ZoomOut</div>
        </div>
        <div id="proc-name" class="proc-name" data-name="" data-rate="1"></div>
    </div>
    <div id="left" class="processes">
        <div class="header">
            <div class="title">
                WorkFlow List
            </div>
            <div class="close">
                &times;
            </div>
        </div>
        <div class="bodyer">
            <div id="process" class="items">

            </div>
        </div>
    </div>
    <div id="right" class="components">
        <div class="header">
            <div class="title">
                Node
            </div>
            <div class="close">
                &times;
            </div>
        </div>
        <div class="bodyer">
            <div id="nodes" class="items nodes">
                <div class="item start" data-type="start">
                    <div class="icon"></div>
                    Start
                </div>
                <div class="item fork" data-type="fork">
                    <div class="icon"></div>
                    Fork
                </div>
                <div class="item join" data-type="join">
                    <div class="icon"></div>
                    Join
                </div>
                <div class="item task" data-type="task">
                    <div class="icon"></div>
                    Task
                </div>
                <div class="item decision" data-type="decision">
                    <div class="icon"></div>
                    Decision
                </div>
                <div class="item end" data-type="end">
                    <div class="icon"></div>
                    End
                </div>
            </div>
            <div id="property" class="fields property">
                <div class="field">
                    <div class="field-label">ID</div>
                    <div class="field-content">
                        <input id="node-id" class="form-control" readonly/>
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">Name</div>
                    <div class="field-content">
                        <input id="node-name" class="form-control"/>
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">Type</div>
                    <div class="field-content">
                        <input id="node-type" class="form-control" readonly/>
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">Script</div>
                    <div class="field-content">
                        <div class="input-group">
                            <select id="node-script-type" class="form-control">
                                <option value=""></option>
                                <option value="java">java</option>
                                <option value="js">js</option>
                                <option value="jsfile">jsfile</option>
                            </select>
                            <span class="input-group-btn">
                            <button id="btn-script-code" class="btn btn-default" type="button">Code</button>
                          </span>
                        </div><!-- /input-group -->
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">TaskId</div>
                    <div class="field-content">
                        <select id="node-taskid" class="form-control">
                            <option value=""></option>
                            <c:forEach var="item" items="${tasks}">
                                <option value="${item.id}">
                                    <c:out value="${item.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<section>
    <div id="prompt-dialog" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">Prompt</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <div class="bs-component prompt-message">

                        </div>
                        <div class="bs-component pv-10">
                            <input class="form-control" value=""/>
                        </div>
                        <div class="bs-component prompt-tip">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancle</button>
                    <button type="button" class="btn btn-primary btn-confirm">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div id="code-dialog" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">Code Editor</h4>
                </div>
                <div class="modal-body">
                    <div id="editor" class="editor" style="height: 400px;width: 100%"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancle</button>
                    <button type="button" class="btn btn-primary btn-confirm">OK</button>
                </div>
            </div>
        </div>
    </div>
</section>
<script src="/js/jquery.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/linker.js"></script>
<script src="/js/ace/ace.js"></script>
<script src="/js/linker.bpms.js"></script>
<script>
    var bpm = undefined;
    var linker = undefined;
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/chrome");
    editor.setHighlightActiveLine(true);
    editor.setShowPrintMargin(true);
    editor.getSession().setUseWrapMode(true);
    editor.getSession().setMode("ace/mode/javascript");
    window.__updateInstanceState__ = function (result) {
        var _instance = result.instance;
        $("#run-status-dialog").removeClass("hidden");
        $("#instance-id").text(_instance.id);
        var _state = _instance.done == true ? "complete" : "running";
        $("#instance-state").text(_state).removeClass("running complete").addClass(_state);
        var variableMap = _instance.variableMap;
        var html = [];
        for (var key in variableMap) {
            html.push("<tr>");
            html.push("<td>");
            html.push(key);
            html.push("</td>");
            html.push("<td>");
            if (typeof(variableMap[key]) === "object") {
                html.push(JSON.stringify(variableMap[key]));
            } else {
                html.push(variableMap[key]);
            }
            html.push("</td>");
            html.push("</tr>");
        }
        $("#instance-variables").html(html.join(""));
        for (var i = 0; i < _instance.executeHistories.length; i++) {
            var _history = _instance.executeHistories[i];
            $(".linker_node.node_" + _history.node).removeClass("enter finished").addClass(_history.status);
        }
        html = [];
        for (var i = 0; i < _instance.tokenNodes.length; i++) {
            var _nodeId = _instance.tokenNodes[i];
            var _bnode = bpm.__nodes__[_nodeId];
            html.push('<div class="btn btn-default btn-xs btn-token ml-5" data-id=' + _nodeId + '>' + _bnode.name + '</div>');
        }
        $("#instance-token-nodes").html(html.join(""));
    };
    window.__signal__ = function (nodeId) {
        itAjax().action("/srv/workflow/signal_workflow_instance").params({
            node: nodeId
        }).success(function (result) {
            if (result.errorCode != 0) {
                bpms.dialog.error(result.errorMessage);
                return;
            }
            window.__refresh__();
        }).error(function () {
            bpms.dialog.error("error try later");
        }).complete(function () {
        }).invoke();
    };
    window.__run__ = function () {
        var _name = $("#proc-name").data("name");
        itAjax().action("/srv/workflow/start_workflow_instance").params({
            name: _name
        }).success(function (result) {
            if (result.errorCode != 0) {
                bpms.dialog.error(result.errorMessage);
                return;
            }
            window.__updateInstanceState__(result);
        }).error(function () {
            bpms.dialog.error("error try later");
        }).complete(function () {
        }).invoke();
    };
    window.__refresh__ = function () {
        var _name = $("#proc-name").data("name");
        itAjax().action("/srv/workflow/get_workflow_instance").params({
            name: _name
        }).success(function (result) {
            if (result.errorCode != 0) {
                bpms.dialog.error(result.errorMessage);
                return;
            }
            window.__updateInstanceState__(result);
        }).error(function () {
            bpms.dialog.error("error try later");
        }).complete(function () {
        }).invoke();
    }
    window.__render__ = function (procObj) {
        $("#linker").html("");
        linker = $("#linker").linker({settingIcon: false});
        bpm = new Bpm(linker, procObj.name, procObj.name);
        bpm.setIdCounter(procObj.counter);
        bpm.setLastPosition(procObj.lastX, procObj.lastY);
        var i, _node;
        for (i = 0; i < procObj.nodes.length; i++) {
            _node = procObj.nodes[i];
            var bnode = bpm.addCustomer(_node.id, _node.name, _node.type, _node.x, _node.y);
            bnode.taskId = _node.taskId;
            bnode.execute = _node.execute;
            bnode.scriptType = _node.scriptType;
        }
        for (i = 0; i < procObj.nodes.length; i++) {
            _node = procObj.nodes[i];
            if (!_node.transtions) {
                continue;
            }
            for (var j = 0; j < _node.transtions.length; j++) {
                bpm.connect(_node.id, _node.transtions[j].to);
            }
        }
        $("#proc-name").text(procObj.name).data("name", procObj.name).removeClass("unsave");
        $("#bpms").addClass("with-right");
        $("#btn-groups").find(".btn.btn-save").addClass("disabled");
    };
    window.__loadWorkflowInstances__ = function () {
        itAjax().action("/srv/workflow/get_workflow_list").params({}).success(function (result) {
            if (!result || !Array.isArray(result.list)) {
                return;
            }
            var _list = result.list;
            var _len = _list.length;
            var html = [];
            for (var i = 0; i < _len; i++) {
                var _item = _list[i];
                html.push('<div class="item" data-name="' + _item.name + '">');
                html.push('<div class="name">' + _item.name + '</div>');
                html.push('<div class="time">' + Date.format(_item.lastModifiedTime, "yyyy-MM-dd hh:mm") + '</div>');
                html.push('</div>');
            }
            $("#process").html(html.join(""));
        }).error(function () {
            bpms.dialog.error("error try later");
        }).complete(function () {
        }).invoke();
    };
    $(function () {
        (function () {
            window.__loadWorkflowInstances__();
        })();
        $("body").on("hidden.bs.modal", "#code-dialog", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            editor.setValue("");
        }).on("changed.bpms", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            var $procName = $("#proc-name");
            $procName.text($procName.data("name") + "*").addClass("unsave");
            $("#btn-groups").find(".btn.btn-save").removeClass("disabled");
        }).on("click", "#show-left", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            $("#bpms").addClass("with-left");
        }).on("change", "#node-taskid", function () {
            if (!bpm || !bpm.activeNode) {
                return;
            }
            bpm.activeNode.taskId = $(this).val();
            $("body").trigger("changed.bpms");
        }).on("change", "#node-script-type", function () {
            if (!bpm || !bpm.activeNode) {
                return;
            }
            bpm.activeNode.scriptType = $(this).val();
            $("body").trigger("changed.bpms");
        }).on("click", "#code-dialog .modal-footer .btn-confirm", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            if (!bpm || !bpm.activeNode) {
                return;
            }
            $("#code-dialog").modal("hide");
            bpm.activeNode.execute = editor.getValue();
            $("body").trigger("changed.bpms");
        }).on("click", "#btn-script-code", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            if (!bpm || !bpm.activeNode) {
                return;
            }
            editor.setValue(bpm.activeNode.execute);
            $("#code-dialog").modal({
                backdrop: "static",
                keyboard: false
            });
        }).on("input", "#node-name", function () {
            if (!bpm || !bpm.activeNode) {
                return;
            }
            bpm.activeNode.refreshName($(this).val());
            $("body").trigger("changed.bpms");
        }).on("click", "#left .close", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            $("#bpms").removeClass("with-left");
        }).on("click", "#show-right", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            $("#bpms").addClass("with-right");
        }).on("click", "#right .close", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            $("#bpms").removeClass("with-right");
        }).on("click", "#process.items .item", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            var $this = $(this);
            if ($this.hasClass("checked")) {
                return;
            }
            if ($("#proc-name").hasClass("unsave")) {
                if (!!bpm && !confirm("current workflow have change,discard?")) {
                    return;
                }
            }
            $("#process.items").find(".item.checked").removeClass("checked");
            $this.addClass("checked");
            var _name = $this.data("name");
            itAjax().action("/srv/workflow/get_workflow_content").params({
                name: _name
            }).success(function (result) {
                var content = result.content;
                window.__render__(JSON.parse(content));
            }).error(function () {
                bpms.dialog.error("error try later");
            }).complete(function () {
                $this.removeClass("requesting");
            }).invoke();
        }).on("click", "#nodes.items .item", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            if (!bpm) {
                return;
            }
            var $this = $(this);
            var _type = $this.data("type");
            bpm.add(_type, _type);
        }).on("click", "#btn-groups .btn.btn-run", function () {
            window.__run__();
        }).on("click", "#btn-groups .btn.btn-create", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            if (!!linker) {
                $("#linker").html("");
            }
            bpms.dialog.prompt("Input workflow name", "", function (result) {
                $("#process.items").find(".item.checked").removeClass("checked");
                linker = $("#linker").linker({settingIcon: false});
                bpm = new Bpm(linker, result, result);
                $("#bpms").addClass("with-right");
                $("#proc-name").text(result).data("name", result);
                $("body").trigger("changed.bpms");
            }, "string", true, 2);
        }).on("click", ".btn-halt", function () {
            $(".linker_node").removeClass("enter finished");
            $("#run-status-dialog").addClass("hidden");
        }).on("click", ".btn-zoomin", function () {
        }).on("click", ".btn-zoomout", function () {

        }).on("click", ".btn-token", function () {
            var $this = $(this);
            var _nodeId = $this.data("id");
            window.__signal__(_nodeId);
        }).on("click", "#btn-groups .btn.btn-save", function () {
            var event = arguments[0] || window.event;
            event.preventDefault();
            var $this = $(this);
            if ($this.hasClass("disabled")) {
                return;
            }
            if ($this.hasClass("requesting")) {
                bpms.dialog.warn("saving please wait");
                return;
            }
            var _name = $("#proc-name").data("name");
            var data = bpm.data();
            $this.addClass("requesting");
            itAjax().action("/srv/workflow/save_workflow_content").params({
                name: _name,
                content: JSON.stringify(data)
            }).success(function (result) {
                if (result.errorCode != 0) {
                    return;
                }
                $("#proc-name").text(_name).data("name", _name).removeClass("unsave");
            }).error(function () {
                bpms.dialog.error("error try later");
            }).complete(function () {
                $this.removeClass("requesting");
            }).invoke();
        });
    });
</script>
</body>
</html>