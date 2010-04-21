# To change this template, choose Tools | Templates
# and open the template in the editor.
def rep(str)
	str = str.gsub("m_c3", "M<sub>c3</sub>")
	str = str.gsub("m_c2", "M<sub>c2</sub>")
	str = str.gsub("m_w1", "M<sub>w1</sub>")
	str = str.gsub("t3_stat", "T<sub>3</sub>")
	str = str.gsub("t2_stat", "T<sub>2</sub>")
	str = str.gsub("t1_stat", "T<sub>1</sub>")
	str = str.gsub("eps_na", "&epsilon;<sub>на</sub>")
	str = str.gsub("eps_rk", "&epsilon;<sub>рк</sub>")
	str = str.gsub("w1", "W<sub>1</sub>")
	str = str.gsub("w2", "W<sub>2</sub>")
	str = str.gsub("w3", "W<sub>3</sub>")
	str = str.gsub("beta3", "&beta;<sub>3</sub>")
	str = str.gsub("beta2", "&beta;<sub>2</sub>")
	str = str.gsub("beta1", "&beta;<sub>1</sub>")
	str = str.gsub("alfa3", "&alpha;<sub>3</sub>")
	str = str.gsub("alfa2", "&alpha;<sub>2</sub>")
	str = str.gsub("alfa1", "&alpha;<sub>1</sub>")
	str = str.gsub("h_lopatky_3", "h<sub>рл3</sub>")
	
	str = str.gsub("pi_k", "&pi;*<sub>к</sub>")
	str = str.gsub("h_ad", "H<sub>ад</sub>")
	str = str.gsub("l_z", "L<sub>z</sub>")
	str = str.gsub("P_l", "P<sub>л</sub>")
	str = str.gsub("G0", "G<sub>0</sub>")
	str = str.gsub("h_rl_vyh", "h<sub>рл3</sub>")
	str = str.gsub("h_rl_1", "h<sub>рл1</sub>")
	str = str.gsub("D_per_3", "D<sub>пер3</sub>")
	str = str.gsub("D_sr_3", "D<sub>ср3</sub>")
	str = str.gsub("D_vt_3", "D<sub>вт3</sub>")
	str = str.gsub("D_per_1", "D<sub>пер1</sub>")
	str = str.gsub("D_sr_1", "D<sub>ср1</sub>")
	str = str.gsub("D_vt_1", "D<sub>вт1</sub>")
	str = str.gsub("D_per_vyh", "D<sub>пер3</sub>")
	str = str.gsub("D_vt_vyh", "D<sub>вт3</sub>")
	str = str.gsub("F_3", "F<sub>3</sub>")
	str = str.gsub("F_1", "F<sub>1</sub>")
	str = str.gsub("ro_vyh", "&rho;<sub>3</sub>")
	str = str.gsub("ro_vh", "&rho;<sub>1</sub>")
	str = str.gsub("SIGMA_vyh", "&sigma;<sub>3</sub>")
	str = str.gsub("SIGMA_vh", "&sigma;<sub>1</sub>")
	str = str.gsub("lambda_vyh", "&lambda;<sub>3</sub>")
	str = str.gsub("lambda_vh", "&lambda;<sub>1</sub>")
	str = str.gsub("lambda_1", "&lambda;<sub>1</sub>")
	str = str.gsub("lambda_2", "&lambda;<sub>2</sub>")
	str = str.gsub("lam_2", "&lambda;<sub>2</sub>")
	str = str.gsub("lambda_3", "&lambda;<sub>3</sub>")
	str = str.gsub("a_kr_vh", "a<sub>кр1</sub>")
	str = str.gsub("Ca_1", "С<sub>a1</sub>")
	str = str.gsub("Ca_vyh", "С<sub>a3</sub>")
	str = str.gsub("L_ud_stupeni", "L<sub>уд</sub>")	
	#str = str.gsub("D_otn_1", "<span style=\"otn\">D<sub>1</sub></span>")
	#str = str.gsub("D_otn_3", "<span style=\"otn\">D<sub>3</sub></span>")
	#str = str.gsub("D_otn_vyh", "<span style=\"otn\">D<sub>3</sub></span>")
	#str = str.gsub("D_otn_vh", "<span style=\"otn\">D<sub>1</sub></span>")
	#str = str.gsub("C_a_otn_3", "<span style=\"otn\">С<sub>a3</sub></span>")
	#str = str.gsub("C_u_otn_3", "<span style=\"otn\">С<sub>u3</sub></span>")
	#str = str.gsub("C_a_otn_1", "<span style=\"otn\">С<sub>a1</sub></span>")
	#str = str.gsub("C_u_otn_1", "<span style=\"otn\">С<sub>u1</sub></span>")
	str = str.gsub("D_otn_1", "<span >D<sub>1</sub></span>")
	str = str.gsub("D_otn_3", "<span >D<sub>3</sub></span>")
	str = str.gsub("D_otn_vyh", "<span >D<sub>3</sub></span>")
	str = str.gsub("D_otn_vh", "<span >D<sub>1</sub></span>")
	str = str.gsub("C_a_otn_3", "<span >С<sub>a3</sub></span>")
	str = str.gsub("C_u_otn_3", "<span >С<sub>u3</sub></span>")
	str = str.gsub("C_a_3_otn", "<span >С<sub>a3</sub></span>")
	str = str.gsub("C_u_3_otn", "<span >С<sub>u3</sub></span>")
	str = str.gsub("C_a_otn_1", "<span >С<sub>a1</sub></span>")
	str = str.gsub("C_u_otn_1", "<span >С<sub>u1</sub></span>")
	return str
end

	
file = File.open('input.txt')
puts "<html>"
puts "<head>"
puts "<link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\">"
puts "</head>"
puts "<body>"
for f in file do
	puts rep(f)+"<br>"
end
puts "</body>"
puts "</html>"





