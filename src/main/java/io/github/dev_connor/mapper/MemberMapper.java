package io.github.dev_connor.mapper;

import io.github.dev_connor.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid);
	public int join(MemberVO member);
}
