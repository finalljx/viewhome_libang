var cherry = new Object();
cherry.bridge = (function () {
	var bridge = new Object();

	var __nativeReadyQueue = new Array();
	var __scriptReadyQueue = new Array();

	var __runningOperations = new Object();

	bridge._beginNativeOperation = function () {
		var operation = __nativeReadyQueue.shift();
		if (operation != undefined) {
			__runningOperations[operation.__index] = operation;
			return operation.toString();
		} else
			return "";
	};

	bridge._endNativeOperation = function (returnStatus) {
		var operation = __runningOperations[returnStatus.index];
		if (operation) {
			operation.returnValue = returnStatus.returnValue;
			operation.stateCode = returnStatus.stateCode;
			operation._complete();
			delete __runningOperations[returnStatus.index];
		}
	};

	bridge._executeScriptOperations = function () {
		var operation = undefined;
		var executed = false;
		if ((operation = __scriptReadyQueue.shift()) != undefined) {
			operation._execute();
			operation._complete();
			executed = true;
		}
		return executed;
	};

	bridge._batchScriptOperations = function () {
		var count = 0;
		while (bridge._executeScriptOperations())
			count ++;
		return count;
	};

	var __bridgeFrame = (function () {
		frame = document.createElement("iframe");
		frame.setAttribute("width", "0px");
		frame.setAttribute("height", "0px");
		frame.setAttribute("id", "cherry_bridge_frame");
		frame.setAttribute("src", "bridge://localhost/flush");
		document.documentElement.appendChild(frame);
		return frame;
	})();

	bridge.flushOperations = function () {
		var frame = document.getElementById("cherry_bridge_frame");
		//frame.contentDocument.location.reload();
		frame.src = frame.src;
	};

	/**
	 * @class cherry.bridge.Operation
	 * @memberof cherry.bridge
	 * @brief The base class of operations
	 */
	var Operation = function () {
		/**
		 * @detail The operation state
		 *  state 0, not dispatched
		 *  state 1, waiting
		 *  state 2, in ready queue
		 *  state 3, finished
		 *
		 */
		this.__state = 0;
		this.__stateListener = undefined;
		this.__depCount = 0;
		this.__followers = new Array();
	};

	Operation.prototype.isDispatched = function () {
		return this.__state > 0;
	};

	Operation.prototype.isWaiting = function () {
		return this.__state == 1;
	};

	Operation.prototype.isReady = function () {
		return this.__state == 2;
	};

	Operation.prototype.isFinished = function () {
		return this.__state >= 3;
	};

	Operation.prototype._setState = function (state) {
		if (state != this.__state) {
			this.__state = state;
			if (this.stateListener != undefined)
				this.stateListener(state);
		}
	};

	Operation.prototype._complete = function () {
		this._setState(3);
		var follower = undefined;
		while ((follower = this.__followers.shift()) != undefined) {
			if ((-- follower.__depCount) == 0)
				follower._ready();
		}
	};

	Operation.prototype._ready = function () {
		this._setState(2);
	};

	Operation.prototype.setStateListener = function (stateListener) {
		if (this.isDispatched())
			throw new Error();
		this.__stateListener = stateListener;
	};

	Operation.prototype.addDependency = function (dependency)  {
		if (! dependency instanceof Operation)
			throw new Error();
		if (! dependency.isDispatched())
			throw new Error();
		if (this.isDispatched())
			throw new Error();
		if (!dependency.isFinished()) {
			dependency.__followers.push(this);
			this.__depCount ++;
		}
		return this;
	};

	Operation.prototype.dispatch = function () {
		if (! this.isDispatched()) {
			this._setState(1);
			if (this.__depCount == 0)
				this._ready();
		}
		return this;
	};

	var ScriptOperation = function (func) {
		Operation.apply(this);
		this.__func = func;
	};

	ScriptOperation.prototype = new Operation();

	ScriptOperation.prototype._ready = function () {
		Operation.prototype._ready.apply(this);
		__scriptReadyQueue.push(this);
	};

	ScriptOperation.prototype._execute = function () {
		this.__func(this);
	};

	var __indexCounter = 0;

	var NativeOperation = function (target, method, args) {
		Operation.apply(this);
		this.__target = target;
		this.__method = method;
		this.__args = args;
		this.__index = __indexCounter;
		__indexCounter = ((__indexCounter + 1) & 0x7fffffff);
	};

	NativeOperation.prototype = new Operation();

	NativeOperation.prototype._ready = function () {
		Operation.prototype._ready.apply(this);
		__nativeReadyQueue.push(this);
	};

	NativeOperation.prototype.toString = function () {
		return JSON.stringify({
			'target' : this.__target,
			'method' : this.__method,
			'args'   : this.__args,
			'index'  : this.__index,
		});
	};

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

		var operation = new ScriptOperation(routine);
		operation.args = params.args;
		operation.dispatch();
		return true;
	};

	return bridge;
})();

