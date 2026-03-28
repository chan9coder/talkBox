<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String rl_tname = request.getParameter("rltname");
String reqstatus = request.getParameter("reqstatus"); // submit 버튼의 값을 저장할 변수
System.out.println(rl_tname);
int rl_idx = Integer.parseInt(request.getParameter("rlidx"));
String rl_reject = request.getParameter("rlreject");
String rl_status = "";
try {
	
	stmt = conn.createStatement();
	if (reqstatus.equals("승인")){
		sql = "create table t_"+ rl_tname +"_list (sl_idx int primary key," +
		" rl_idx int not null, sl_ismem char(1) default 'y', sl_writer varchar(20) not null, " +
		" sl_pw varchar(20), sl_title varchar(100) not null, sl_content text not null," +
		" sl_reply int default 0, sl_read   int   default 0, sl_isview char(1) default 'y',sl_date datetime default now()," +
		" constraint fk_"+ rl_tname +"_list_rl_idx foreign key (rl_idx) references t_req_list(rl_idx))";
		
		stmt.executeUpdate(sql);
		sql = "create table t_"+rl_tname+"_reply (sr_idx int auto_increment primary key," +
				" sl_idx int not null,mi_id varchar(20) not null,sr_pw varchar(20)," +
				" sr_content varchar(200) not null,sr_ismem char(1) default 'y',sr_good int default 0," +
				" sr_bad int default 0,sr_isview char(1) default 'y',sr_date datetime default now(), " +
			   " constraint fk_"+ rl_tname +"_reply_sl_idx foreign key (sl_idx) references t_java_list(sl_idx), " +
			   " constraint fk_"+ rl_tname +"_reply_mi_id foreign key (mi_id) references t_member_info(mi_id))";
		stmt.executeUpdate(sql);
		sql = "create table t_"+rl_tname+"_reply_gnb (srg_idx int auto_increment unique,mi_id varchar(20) not null," +
				   " sr_idx int not null, srg_gnb char(1) default 'g',srg_date datetime default now()," +
				   " constraint pk_"+ rl_tname +"_reply_gnb primary key (mi_id,sr_idx)," +
				   " constraint fk_"+ rl_tname +"_reply_gnb_mi_id foreign key (mi_id) references t_member_info(mi_id)," +
				   " constraint fk_"+ rl_tname +"_reply_gnb_sr_idx foreign key (sr_idx) references t_java_reply(sr_idx))";
		
		stmt.executeUpdate(sql);
		sql = "update t_req_list set rl_status = 'a', rl_tname = '"+ rl_tname +"' where rl_idx = " + rl_idx;	// 테이블 생성 후 rl_status 값을 a(승인)로 변경
		stmt.executeUpdate(sql);
		response.sendRedirect("tbAdminRequestList.jsp");
		
	}else if (reqstatus.equals("반려")){
		try {
			stmt = conn.createStatement();
			sql = "select * from t_req_list where rl_idx = "+ rl_idx;
			rs = stmt.executeQuery(sql);
			
				sql = "update t_req_list set rl_status = 'b' , rl_reject = '"+ rl_reject +"' where rl_idx = "+ rl_idx;	// 테이블 반려 후 rl_status 값을 b(반려)로 변경
				System.out.println(sql);
				stmt.executeUpdate(sql);
				response.sendRedirect("tbAdminRequestList.jsp");
		}catch (Exception e){
		e.printStackTrace();
		}
	} else {
		out.println("<script>");
		out.println("alert('요청글 승인에 실패하였습니다. \\n다시 시도하세요.'); history.back();");
		out.println("</script>");
		out.close();
	}
}catch (Exception e){
	out.println("요청 게시판 생성시 문제가 발생하였습니다.");
	e.printStackTrace();
	
} finally {
	try{
		stmt.close();
	}catch (Exception e){
		e.printStackTrace();
	}
}
%>
<%@ include file="../_inc/inc_foot.jsp" %>