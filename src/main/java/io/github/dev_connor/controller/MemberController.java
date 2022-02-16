package io.github.dev_connor.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import io.github.dev_connor.domain.MemberVO;
import io.github.dev_connor.mapper.MemberMapper;
import io.github.dev_connor.service.BoardService;
import io.github.dev_connor.service.MemberService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@AllArgsConstructor
public class MemberController {
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	private MemberService service;

	@GetMapping("/join")
	public void joinGET() {
		log.info("get join");
	}
	
	@PostMapping("/join")
	public String joinPost(MemberVO member) {
		log.info("post join: " + member);
		service.join(member);
		return "redirect:/board/list";
	}
}
