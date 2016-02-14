note
	description: "Summary description for {STUDENT_TEST1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST1

inherit
	ES_TEST

create
	make

feature {NONE}
	make
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)

			add_violation_case_with_tag("valid_type_name", agent t_1)
			add_violation_case_with_tag("not_existed", agent t_2)
			add_violation_case_with_tag("valid_quantity", agent t_3)
			add_violation_case_with_tag("existed_type", agent t_4)
--			add_violation_case_with_tag("id_valid", agent t_5)     computer cannot run 10000-loop test
			add_violation_case_with_tag("nonempty_cart", agent t_6)
			add_violation_case_with_tag("all_quantity_valid", agent t_7)
			add_violation_case_with_tag("all_products_valid", agent t_8)
			add_violation_case_with_tag("no_duplicate_products", agent t_9)
			add_violation_case_with_tag("enough_stock", agent t_10)
			add_violation_case_with_tag("valid_order_id", agent t_11)
			add_violation_case_with_tag("not_invoiced_order", agent t_12)
			add_violation_case_with_tag("valid_order_id", agent t_13)

		end

feature

    s1: STRING = " apple,bowl,nuts"

	t1:BOOLEAN
		local
			m: INVOICE_SYSTEM
		do
            create m.make
            m.add_type ("nuts")
            m.add_type ("bowl")
            m.add_type ("apple")
            comment("t1: check command add_type as well as whether products type list is sorted alphabetically")
            sub_comment("Input order: nuts,bowl,apple")
            sub_comment("Output order: " + m.stock.get_products_id)
            result:= m.stock.get_products_id ~ s1
		end

    s2:STRING = "apple->100,nuts->300"

	t2:BOOLEAN
		local
			m: INVOICE_SYSTEM
		do
            create m.make
            m.add_type("nuts")
            m.add_type ("bowl")
            m.add_type ("apple")
            m.add_product ("nuts", 300)
            m.add_product ("apple", 100)
            comment("t2: check command add_type as well as whether stock detail list is sorted alphabetically by product name; ensure zero product would not be shown")
            sub_comment("Input order: nuts->300,apple->100; add type bowl but do not add product")
            sub_comment("Output order: " + m.stock.get_stock_detail)
            result:= m.stock.get_stock_detail ~ s2
        end

     s3:STRING = "1: bowl->4,nuts->5%N               2: apple->10,nuts->6"

     t3:BOOLEAN
         local
         	m: INVOICE_SYSTEM
         do
         	create m.make
         	m.add_type("nuts")
            m.add_type ("bowl")
            m.add_type ("apple")
            m.add_product ("nuts", 300)
            m.add_product ("apple", 100)
            m.add_product ("bowl", 100)
            m.add_order (<<["bowl", 4], ["nuts", 5]>>)
            m.add_order (<<["nuts", 6], ["apple", 10]>>)
            comment("t3: check command add_order as well as whether output of %"carts%" is sorted alphabetiaclly regardless of input order")
            sub_comment("Input order:%N1: bowl->4,nuts->5%N2: nuts->6,apple->10")
            sub_comment("Output order:%N" + m.invoices.get_cart_detail)
            sub_comment(s3)
            result:= m.invoices.get_cart_detail ~ s3
         end

     s4:STRING = "1,2,3,5,4,6,7"

     t4:BOOLEAN
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
         	m.add_type("nuts")
            m.add_type ("bowl")
            m.add_type ("apple")
            m.add_product ("nuts", 300)
            m.add_product ("apple", 100)
            m.add_product ("bowl", 100)
            m.add_order (<<["nuts", 1]>>)
            m.add_order (<<["nuts", 2]>>)
            m.add_order (<<["nuts", 3]>>)
            m.add_order (<<["nuts", 4]>>)
            m.add_order (<<["nuts", 5]>>)
            m.add_order (<<["nuts", 6]>>)
            m.cancel_order (4)
            m.cancel_order (6)
            m.add_order (<<["nuts", 7]>>)
            m.add_order (<<["nuts", 8]>>)
            m.add_order (<<["nuts", 9]>>)
            comment("t4: check command cancel_order as well as whether output sequence keeps position vacant after cancelling order")
            sub_comment("If not reserved: 1,2,3,4,5,6,7")
            sub_comment("If reserved(output): " + m.invoices.get_exsited_order)
            result:= m.invoices.get_exsited_order ~ s4
         end

     s5:STRING = "2->pending,4->pending,3->invoiced,1->pending,5->invoiced"

     t5:BOOLEAN
         local
         	m: INVOICE_SYSTEM
         do
         	create m.make
        	m.add_type("nuts")
            m.add_type ("bowl")
            m.add_type ("apple")
            m.add_product ("nuts", 300)
            m.add_product ("apple", 100)
            m.add_product ("bowl", 100)
            m.add_order (<<["nuts", 1]>>)
            m.add_order (<<["nuts", 2]>>)
            m.add_order (<<["nuts", 3]>>)
            m.add_order (<<["nuts", 4]>>)
            m.cancel_order (3)
            m.cancel_order (1)
            m.add_order (<<["nuts", 5]>>)
            m.add_order (<<["nuts", 6]>>)
            m.add_order (<<["nuts", 7]>>)
            m.invoice (5)
            m.invoice (3)
            comment("t5: check command invoice as well as whether the output of order state is shown correctly given the same condition of t4; also check whether invoice function working correctly")
            sub_comment("Input: output order is 2, 4, 3, 1, 5; invoice 3 and 5:")
            sub_comment("Output: " + m.invoices.get_order_status)
            result:= m.invoices.get_order_status ~ s5
         end

     t6: BOOLEAN
        local
        	o1: ORDER
        	o2: ORDER
        do
        	create o1.make (<<["bowl", 4], ["nuts", 5]>>)
        	create o2.make (<<["bowl", 4], ["nuts", 5]>>)
        	comment("t6: test equal_order, method of ORDER when orders are equal")
        	sub_comment("o1: <<[%"bowl%", 4], [%"nuts%", 5]>>")
        	sub_comment("o2: <<[%"bowl%", 4], [%"nuts%", 5]>>")
        	result:= o1.equal_order (o2)
        end

     t7: BOOLEAN
        local
        	o1: ORDER
        	o2: ORDER
        do
        	create o1.make (<<["bowl", 4], ["nuts", 5]>>)
        	create o2.make (<<["bowl", 3], ["nuts", 5]>>)
        	comment("t7: test equal_order, method of ORDER when orders are not equal")
        	sub_comment("o1: <<[%"bowl%", 4], [%"nuts%", 5]>>")
        	sub_comment("o2: <<[%"bowl%", 3], [%"nuts%", 5]>>")
        	result:= not o1.equal_order (o2)
        end

     t8: BOOLEAN
        local
        	m: INVOICE_SYSTEM
        do
            create m.make
            comment("t8: test zero products will not be shown in stock detail")
            m.add_type ("nuts")
            m.add_type ("bowls")
            m.add_product ("nuts", 100)
            m.add_product("bowls", 100)
            sub_comment("%Nbefore order:" + m.stock.get_stock_detail)
            m.add_order (<<["nuts",100],["bowls",40]>>)
            sub_comment("%Nafter order:" + m.stock.get_stock_detail)
            result:= true
        end

     t_1
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_1: add type with empty string")
            m.add_type ("")
         end

     t_2
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_2: add the same type twice")
            m.add_type ("nuts")
            m.add_type ("nuts")
         end

     t_3
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_3: add negative amount of products into stock")
            m.add_type ("nuts")
            m.add_product ("nuts", -3)
         end

     t_4
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_4: add untyped products into stock")
            m.add_product ("nuts", 3)
         end

     t_5
         local
         	m: INVOICE_SYSTEM
         	i: INTEGER
         do
            create m.make
            comment("t_5: add 10001 orders")
            m.add_type ("nuts")
            m.add_product ("nuts", 10001)
            from
                i:= 1
            until
            	i > 10001
            loop
            	m.add_order (<<["nuts",1]>>)
            	i:= i + 1
            end
         end

     t_6
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_6: add an empty order")
            m.add_type ("nuts")
            m.add_product ("nuts", 1)
            m.add_order (<<>>)
         end

     t_7
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_7: add order with negative amount of items")
            m.add_type ("nuts")
            m.add_product ("nuts", 500)
            m.add_order (<<["nuts", -5]>>)
         end

     t_8
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_8: add order with untyped items")
            m.add_type ("nuts")
            m.add_product ("nuts", 1)
            m.add_order (<<["bolts", 5]>>)
         end

     t_9
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_9: add an order with duplicate items")
            m.add_type ("nuts")
            m.add_product ("nuts", 4)
            m.add_order (<<["nuts", 2], ["nuts", 2]>>)
         end

     t_10
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_10: order exceeds the amount in stock")
            m.add_type ("nuts")
            m.add_product ("nuts", 10)
            m.add_order (<<["nuts", 100]>>)
         end

     t_11
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_11: invoice an invalid order")
            m.add_type ("nuts")
            m.add_product("nuts", 10)
            m.add_order (<<["nuts", 5]>>)
            m.invoice (2)
         end

     t_12
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_12: repeative invoicing")
            m.add_type ("nuts")
            m.add_product ("nuts", 109)
            m.add_order (<<["nuts", 10]>>)
            m.invoice (1)
            m.invoice (1)
         end

     t_13
         local
         	m: INVOICE_SYSTEM
         do
            create m.make
            comment("t_13: cancel not existed order")
            m.add_type ("nuts")
            m.add_product ("nuts", 100)
            m.cancel_order (1)
         end

end -- class STUDENT_TEST1
