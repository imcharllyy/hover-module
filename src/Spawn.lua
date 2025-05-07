--[[
    Use this over "spawn" & "task.spawn"
    
    Accepts a function or a thread (as returned by coroutine.create) and calls/resumes it immediately
    through the engine's scheduler. Arguments after the first are sent to the function/thread.
]]

local freeThread: thread? = nil

local function FunctionPasser(callback, ...)
	local aquiAetherThread = freeThread
	freeThread = nil
	callback(...)

	if not freeThread then
		freeThread = aquiAetherThread
	end
end

local function Yielder()
	FunctionPasser(coroutine.yield())

	while freeThread == coroutine.running() do
		FunctionPasser(coroutine.yield())
	end
end

--[[
	<strong>Executes a callback on a free thread, reusing threads to optimize performance.</strong>
	<code>@param callback (function): The function to be executed on the thread.</code>
	<code>@param ... (any): Arguments to be passed to the callback function.</code>
	<code>@return thread: The thread on which the callback is executed.</code>
]]
return function<T...>(callback: (T...) -> (), ...: T...): thread
	freeThread = freeThread or task.spawn(Yielder)
	return task.spawn(freeThread :: thread, callback, ...)
end
