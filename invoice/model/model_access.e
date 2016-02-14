note
	description: "Summary description for {MODEL_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	INVOICE_SYSTEM_ACCESS

feature
	m: INVOICE_SYSTEM
		once
			create Result.make
		end

invariant
	m = m
end

