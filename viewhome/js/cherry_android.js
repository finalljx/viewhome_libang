var cherry = new Object();

cherry.bridge = (function () {
	var bridge = new Object();

	var __runningOperations = new Object();

	bridge._nativeOperationDidComplete = function (returnStatus) {
		var operation = __runningOperations[returnStatus.operationID];
		if (operation) {
			operation.returnValue = returnStatus.returnValue;
			operation.stateCode = returnStatus.stateCode;
			// alert("delete native operation " + returnStatus.operationID);
			delete __runningOperations[returnStatus.operationID];
		}
	};

	bridge._runScriptOperation = function (operationID) {
		var operation = __runningOperations[operationID];
		if (operation) {
			if (operation.__func) {
				// alert("running script operation:\n"+operation.__func);
				operation.__func.apply();
			}
			// alert("delete script operation " + returnStatus.operationID);
			delete __runningOperations[operationID];
		}
	};

	bridge.flushOperations = function () {
		cherry_bridge.Bridge_flush();
	};

	/**
	 * @class cherry.bridge.Operation
	 * @memberof cherry.bridge
	 * @brief The base class of operations
	 */
	var Operation = function (operationID) {
		// alert('operation: '+operationID);
		this.__operationID = operationID;
		if (__runningOperations[operationID]) {
			alert("Internal error, an existing operation #" + operationID + "is overrided");
		} else {
			__runningOperations[operationID] = this;
		}
	};

	Operation.prototype.addDependency = function (dependency)  {
		cherry_bridge.Operation_addDependency(this.__operationID, dependency.__operationID);
		return this;
	};

	Operation.prototype.dispatch = function () {
		cherry_bridge.Operation_dispatch(this.__operationID);
		return this;
	};

	var ScriptOperation = function (func) {
		var operationID = cherry_bridge.Bridge_createScriptOperation();
		// alert("create script operation #" + operationID);
		Operation.apply(this, [ operationID ]);
		this.__func = func;
	};


	var NativeOperation = function (target, method, args) {
		var operationID = cherry_bridge.Bridge_createNativeOperation(target, method, args);
		// alert("create native operation #" + operationID);
		Operation.apply(this, [ operationID ]);
		this.__target = target;
		this.__method = method;
		this.__args = args;
	};

	operationProto = new Operation(-1);
	ScriptOperation.prototype = operationProto;
	NativeOperation.prototype = operationProto;

	bridge.ScriptOperation = ScriptOperation;
	bridge.NativeOperation = NativeOperation;

	var __eventHandlers = new Object();

	bridge.registerEvent = function (target, eventName, routine) {
		if (__eventHandlers[target] == undefined)
			__eventHandlers[target] = new Object();
		__eventHandlers[target][eventName] = routine;
	};

	bridge._fireEvent = function (params) {
		var target = __eventHandlers[params.source];
		if (!target) {
			return false;	
		}

		var routine = target[params.eventName];
		if (!routine) {
			return false;	
		}
		routine();
		return true;
	};

	return bridge;
})();

