<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/WEB-INF/views/include/title.jsp" %>
</head>
<body>
	<h1>회원가입</h1>
	<h2><c:out value="${error}" /></h2>
	<h2><c:out value="${logout}" /></h2>

	<form method='post' action="/join">
		<div>
			아이디: <input type='text' name='userid' autofocus>
		</div>
		<div>
			비밀번호: <input type='password' name='userpw'>
		</div>
		<div>
			이름: <input type='text' name='userName'>
		</div>
<!-- 		<div> -->
<!-- 			권한: <input type='text' name='authList'> -->
<!-- 		</div> -->

		<div>
			<input type='submit'>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form>
</body>
</html>
