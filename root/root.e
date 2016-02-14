note
	description: "Summary description for {ROOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT
inherit
	ROOT_INTERFACE
	  rename make as make_from_root end
	ES_SUITE
create
	make
feature {NONE}
	unit_test: BOOLEAN = true
	 make
	 	do
	 		initialize_attributes
	 		if unit_test then
	 			-- add your test here...
	 			add_test (create {STUDENT_TEST1}.make)
	 			show_browser
	 			run_espec
	 		else
	 			make_from_root
	 		end
	 	end
end
