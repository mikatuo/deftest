local reporter = require "luacov.reporter"

local DefoldReporter = setmetatable({}, reporter.DefaultReporter) do
	DefoldReporter.__index = DefoldReporter

	function DefoldReporter:run()
		print("Generating code coverage report")
		self:on_start()

		-- convert filenames to match those on disk
		-- filenames will start with =/ since they aren't coming
		-- from files on disk when run in Defold
		local d = {}
		for filename,stats in pairs(self._data) do
			d[filename:gsub("=/", ""):gsub("=", "")] = stats
		end
		self._data = d
		for i,filename in pairs(self._files) do
			self._files[i] = filename:gsub("=/", ""):gsub("=", "")
		end
		
		for _, filename in ipairs(self:files()) do
			-- check if file exists
			local file = io.open(filename, "r")
			if file then
				print("  Processing:", filename)
				self:_run_file(filename)
			else
				print("  Skipping:", filename)
			end
		end

		self:on_end()
	end
	
end

return DefoldReporter