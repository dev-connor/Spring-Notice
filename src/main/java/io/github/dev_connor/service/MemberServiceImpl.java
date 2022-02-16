package io.github.dev_connor.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import io.github.dev_connor.domain.BoardVO;
import io.github.dev_connor.domain.Criteria;
import io.github.dev_connor.domain.MemberVO;
import io.github.dev_connor.mapper.BoardMapper;
import io.github.dev_connor.mapper.MemberMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

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