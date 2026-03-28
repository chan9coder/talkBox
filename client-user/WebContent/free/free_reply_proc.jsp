<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head.jsp"%>
<%
request.setCharacterEncoding("utf-8");
String kind = request.getParameter("kind");
int cpage = Integer.parseInt(request.getParameter("cpage"));
int fl_idx = Integer.parseInt(request.getParameter("fl_idx"));
String schtype = request.getParameter("schtype");		// 검색조건
String keyword = request.getParameter("keyword");		// 검색어
String args = "?cpage="+cpage +"&idx="+ fl_idx;
if(!(schtype == null || schtype.equals("") || keyword == null || keyword.equals(""))){	//검색을 하지 않는 경우
	args += "&schtype="+ schtype + "&keyword=" + keyword;
}

int fr_idx = 0;			//댓글 번호를 저장할 변수
String fr_content = request.getParameter("fr_content");
String mi_id =loginInfo.getMi_id();
if(!kind.equals("in")){	//댓글 등록이 아닐 경우
	fr_idx=Integer.parseInt(request.getParameter("fr_idx"));
}

try{
	stmt= conn.createStatement();
	if(kind.equals("in")){			//댓글 등록일 경우
			//게시글의 댓글 수 증가 쿼리 실행
		System.out.print("------"+mi_id);
		sql = "insert into t_free_reply (fl_idx, mi_id, fr_content) values ('"+
		fl_idx + "', '" + mi_id + "', '" + fr_content +"')";	
	}else if(kind.equals("up")){	//댓글 수정일 경우
		sql ="update t_free_reply set fr_content = '" + fr_content + "'where mi_id='"+loginInfo.getMi_id() +"' and fr_idx="+fr_idx;
			
	}else if(kind.equals("del")){	//댓글 삭제일 경우
		sql = "update t_free_list set fl_reply = fl_reply - 1 where fl_idx="+fl_idx;
		stmt.executeUpdate(sql);	//게시글의 댓글 수 증가 쿼리 실행
		
		sql = "update t_free_reply set fr_isview= 'n' where mi_id='"+loginInfo.getMi_id() +"' and fr_idx="+fr_idx;
		
	}else if(kind.equals("g") || kind.equals("b")){		//댓글 좋아요 및 싫어요일 경우
		sql = "update t_free_reply set fr_"+(kind.equals("g") ? "good":"bad") +" = fr_"+ (kind.equals("g") ? "good":"bad") +" + 1 where fr_idx ="+fr_idx;
		stmt.executeUpdate(sql);	//댓글의 좋아요/싫어요의 수 증가 쿼리 실행
		
		sql = "insert into t_free_reply_gnb (mi_id, fr_idx, frg_gnb) values('"+mi_id +"', "+fr_idx+",'"+ kind +"') ";
	}else{
		out.print("<script>");
		out.print("history.back();");
		out.print("</script>");
	}//12
	//System.out.print(sql);
	int result = stmt.executeUpdate(sql);
	out.print("<script>");
	if(result ==1){
		sql = "update t_free_list set fl_reply = fl_reply + 1 where fl_idx="+fl_idx;
		stmt.executeUpdate(sql);
		out.print("location.replace('tbfreeView.jsp"+ args+ "');");
	} else {
		out.print("alert('댓글 등록에 실패했습니다.\\n다시 시도하세요.');");
		out.print("history.back();");	
	}
	out.print("</script>");
		
}catch(Exception e){
	out.println("댓글 관련 문제가 발생했습니다.");
	e.printStackTrace();
}finally{
	try{
		stmt.close();
	} catch(Exception e){
		e.printStackTrace();
	}
}



%>
<%@ include file="../_inc/inc_foot.jsp"%>