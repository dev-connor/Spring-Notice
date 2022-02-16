package io.github.dev_connor.service;

import java.util.List;

import io.github.dev_connor.domain.BoardVO;
import io.github.dev_connor.domain.Criteria;
import io.github.dev_connor.domain.MemberVO;

public interface MemberService {
	public void join(MemberVO member);
}