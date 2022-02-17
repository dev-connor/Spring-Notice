# 게시판 프로젝트

이 프로젝트는 개인 프로젝트입니다.

스프링으로 게시판을 구현한 프로젝트입니다.

기능위주로 구현하고 디자인적 요소는 최소화했습니다.

---

### 목차
1. 환경설정
    - JDBC
3. 회원가입
    - 비밀번호 암호화 처리
4. 글 목록
5. 글 작성 & 로그인
    - Spring security 의 CSRF
    - 로그인 권한처리
    - 로그인상태에 따른 동적 화면구현
6. 글 수정 & 글 삭제
    - 권한에 따른 수정/삭제
7. 페이징처리

### 적용된 다른 기능


1. 로그인과 DB 연결
9. 로그아웃 기능

---

### 1. 환경설정

#### JDBC

이번 프로젝트는 mybatis 의 커넥션 풀의 한 종류인 Hikari CP 를 사용합니다.

<br>

**WEB-INF/spring/root-context.xml**

```xml
	<bean id="hikariConfig" class="com.zaxxer.hikari.HikariConfig">
	    <property name="driverClassName" value="net.sf.log4jdbc.sql.jdbcapi.DriverSpy"></property>
	    <property name="jdbcUrl" value="jdbc:log4jdbc:oracle:thin:@localhost:1521:xe"></property>
	    <property name="username" value="board"></property>
	    <property name="password" value="tiger"></property>
	</bean>
	<bean id="dataSource" class="com.zaxxer.hikari.HikariDataSource" destroy-method="close">
	    <constructor-arg ref="hikariConfig"></constructor-arg>
	</bean>	
	<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
	    <property name="dataSource" ref="dataSource"></property>
	    <property name="typeAliases">
	        <list> 
	            <value>io.github.dev_connor.domain.BoardVO</value>
	            <value>io.github.dev_connor.domain.MemberVO</value>
	            <value>io.github.dev_connor.domain.AuthVO</value>
	        </list>
	    </property>		    
	</bean>
	<mybatis-spring:scan base-package="io.github.dev_connor.mapper"/>	
```

### 2. 회원가입

<img width="750" alt="회원가입" src="https://user-images.githubusercontent.com/70655507/154285678-6a0d63c2-87a7-4144-92a1-851d1084f5d6.PNG">

> 아이디에 ryan, 비밀번호에 aa1234 로 회원가입을 합니다.
<br>

<img width="750" alt="암호화" src="https://user-images.githubusercontent.com/70655507/154287334-3076ed3e-8f7b-42ec-9286-3598defcf03d.PNG">

> 비밀번호가 암호화되어 DB 에 저장됩니다.
<br>

**WEB-INF/spring/security-context.xml**
```java
<bean id="bcryptPasswordEncoder" class="org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder"></bean>

<security:authentication-manager> 
	<security:authentication-provider user-service-ref="customUserDetailsService">
		<security:password-encoder ref="bcryptPasswordEncoder"/>
	</security:authentication-provider>
</security:authentication-manager>
```

`BCryptPasswordEncoder` 스프링프레임워크의 패스워드 인코더를 사용합니다.

<br>

**컨트롤러**

```java
@Controller
@Log4j
@AllArgsConstructor
public class MemberController {
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	private MemberService service;

	@GetMapping("/join")
	public void joinGET() {
	}
	
	@PostMapping("/join")
	public String joinPost(MemberVO member) {
		service.join(member);
		return "redirect:/board/list";
	}
}
```
<br>

**서비스**

```java
@Log4j
@Service
@AllArgsConstructor
public class MemberServiceImpl implements MemberService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;

	@Override
	public void join(MemberVO member) {
		String encodedPW = pwencoder.encode(member.getUserpw());
		member.setUserpw(encodedPW);
		mapper.join(member);
	}
}
```

`pwencoder.encode` 비밀번호를 암호화합니다.


### 3. 글 목록
<img width="750" alt="DB" src="https://user-images.githubusercontent.com/70655507/154282823-82103c36-9517-4951-919b-292de6ca30fa.PNG">
<img width="750" alt="글목록" src="https://user-images.githubusercontent.com/70655507/154280388-1352b509-7277-48cb-9d4b-1a59d42e953a.PNG">
<br>

**컨트롤러**

```java
@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	private BoardService service;

	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		int total = service.getTotal(cri);
		
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
}  
```

<br>

**서비스**

```java
@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	@Override
	public List<BoardVO> getList(Criteria cri) {
		return mapper.getListWithPaging(cri);
	}
}
```

<br>

**MyBatis**

```xml
<select id="getListWithPaging" resultType="BoardVO"> 
<![CDATA[ 
  SELECT bno, title, content, writer, regdate, updatedate  
  FROM (  
    SELECT /*+INDEX_DESC(tbl_board pk_board) */  
      rownum rn, bno, title, content, writer, regdate, updatedate  
    FROM tbl_board  
    WHERE rownum <= #{pageNum} * #{amount}  
    )  
  WHERE rn > (#{pageNum} -1) * #{amount}  
]]>  
</select>
```

### 4. 글 작성 & 로그인
<img width="750" alt="로그인" src="https://user-images.githubusercontent.com/70655507/154280439-58771c56-d740-419e-8f4b-b092d478125c.PNG">

> 로그인이 되어있지 않다면 글쓰기버튼을 클릭 시 로그인페이지로 연결됩니다.
<br>

#### - 글 작성 시 로그인 페이지로

<br>

**WEB-INF/spring/appServlet/servlet-context.xml**

```xml
<security:global-method-security pre-post-annotations="enabled" secured-annotations="enabled"/>
```

**컨트롤러**

```java
@GetMapping("/register")
@PreAuthorize("isAuthenticated()")
public void register() {}

@PostMapping("/register")
@PreAuthorize("isAuthenticated()")
public String register(BoardVO board, RedirectAttributes rttr) {
	service.register(board);
	rttr.addFlashAttribute("result", board.getBno());
	return "redirect:/board/list";
}
```

`@PreAuthorize("isAuthenticated()")` 어노테이션으로 로그인한 사용자만 글작성을 하도록 합니다.

<br>

#### - 로그인 CSRF

```jsp
<form method='post' action="/login">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

	<div><input type='text' name='username' autofocus></div>
	<div><input type='password' name='password'></div>
	<div><input type='checkbox' name='remember-me'> Remember Me</div>

	<div><input type='submit'></div>
</form>
```

> Spring security 에서는 모든 POST 방식의 form 태그에 CSRF 토큰이 필요합니다.

<img width="750" alt="글작성" src="https://user-images.githubusercontent.com/70655507/154280449-79be4a67-2fb5-4ec0-80cb-1f96240eb7ef.PNG">

> 아까 가입한 ryan/aa1234 로 로그인합니다. <br>
> 암호화된 비밀번호는 디코드되어 비밀번호가 일치하는지 확인한 후 로그인됩니다. <br>
> 로그인 후에는 바로 글작성페이지로 이동됩니다.
<br>

**MyBatis**

```xml
<insert id="insertSelectKey">
<selectKey keyProperty="bno" order="BEFORE" resultType="long">
 select seq_board.nextval from dual
</selectKey>
insert into tbl_board (bno,title,content, writer)
values (#{bno}, #{title}, #{content}, #{writer})
</insert>    
```

<img width="750" alt="글작성_완료" src="https://user-images.githubusercontent.com/70655507/154280458-4dfe496c-5013-4cf5-9ec6-3226a4f67bdb.PNG">
<img width="750" alt="글작성_완료2" src="https://user-images.githubusercontent.com/70655507/154280468-403cfaf6-c44d-47c3-8056-9a5aab89dcc9.PNG">

> 글 작성이 정상적으로 된 것을 확인할 수 있습니다. <br>
> 로그인 후에는 '로그인', '회원가입' 버튼이 '로그아웃' 버튼으로 바뀐 것을 볼 수 있습니다.
<br>

### 5. 글 수정 & 글 삭제
<img width="750" alt="글상세_타인" src="https://user-images.githubusercontent.com/70655507/154280602-9d202877-f7bf-4f6e-b72e-4d9327bbed62.PNG">

> 다른사람의 글은 수정, 삭제할 수 없습니다.
<br>

<img width="750" alt="글상세" src="https://user-images.githubusercontent.com/70655507/154280671-80690767-686c-4546-ba39-3f16ba8a1925.PNG">

> 자신의 글에는 수정, 삭제버튼이 생긴 것을 볼 수 있습니다.
<br>

**글상세.jsp**

```jsp
<sec:authentication property="principal" var="p"/>
<sec:authorize access="isAuthenticated()">
	<c:if test="${p.username eq board.writer }">
		<button data-oper='modify' class="btn btn-default">
			<a href="/board/modify?bno=<c:out value='${board.bno}'/>">수정</a>
		</button>			
		<form role="form" action="/board/remove?bno=${board.bno }" method="post">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			<button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
		</form>
	</c:if>
</sec:authorize>
```

<img width="750" alt="글수정" src="https://user-images.githubusercontent.com/70655507/154280701-5d7d7d53-43f9-4fb9-be8b-c312cbbfda1b.PNG">
<img width="750" alt="글수정_완료" src="https://user-images.githubusercontent.com/70655507/154280706-140540ab-4c89-4a6d-8d0c-d52ff8305dcd.PNG">

> 글 수정이 완료된 후에는 글상세페이지로 이동됩니다.
<br>

<img width="750" alt="글삭제" src="https://user-images.githubusercontent.com/70655507/154280806-18761a56-e675-4d01-9a12-424d2643adff.PNG">

> 글삭제가 정상적으로 된 것을 볼 수 있습니다.
<br>

### 6. 페이징처리
<img width="750" alt="글작성_완료2" src="https://user-images.githubusercontent.com/70655507/154280853-cbd6e8a7-aa44-4227-ab3b-5a268244ef12.PNG">
<img width="750" alt="페이징처리_중간" src="https://user-images.githubusercontent.com/70655507/154280867-d8d24300-951b-4c11-b59c-5a6ddf34d154.PNG">

> 페이지의 중간에서는 이전버튼 (Previous) 과 다음버튼 (Next) 가 모두 보이는 것을 볼 수 있습니다.
<br>

<img width="750" alt="페이징처리_끝" src="https://user-images.githubusercontent.com/70655507/154280861-f784ab9c-5bab-4e47-9393-3004525c6133.PNG">

> 반면에 처음과 마지막페이지에서는 이전버튼이나 다음버튼이 없도록 처리했습니다.
<br>
