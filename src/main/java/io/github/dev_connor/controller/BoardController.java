package io.github.dev_connor.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.dev_connor.domain.BoardVO;
import io.github.dev_connor.domain.Criteria;
import io.github.dev_connor.domain.PageDTO;
import io.github.dev_connor.service.BoardService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
   private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
   private  BoardService service;

   @GetMapping("/list")
   public void list(Model model) {
      log.info("list");
      model.addAttribute("list", service.getList());
   }
   
//	@GetMapping("/list")
//	public void list(Criteria cri, Model model) {
//
//		log.info("list: " + cri);
//		model.addAttribute("list", service.getList(cri));
		
		
//		model.addAttribute("pageMaker", new PageDTO(cri, 123));

//		int total = service.getTotal(cri);
//		log.info("total: " + total);
//		model.addAttribute("pageMaker", new PageDTO(cri, total));
//	}


   
   @GetMapping("/register")
   public void register() {   }
   
   // p.216
   @PostMapping("/register")
   public String register(BoardVO board, RedirectAttributes rttr) { 
      log.info("register: " + board);
      service.register(board);
      //
      // 일회성 전달
      // bno 가 selectKey 에 의해 먼저 실행되고 board 객체에 설정됨..
      // ***** 활용 기억  : board.getBno()  *****
      rttr.addFlashAttribute("result", board.getBno());
      return "redirect:/board/list";
   }

   // p.218
//   @GetMapping({ "/get", "/modify" })
//   public void get(@RequestParam("bno") Long bno, Model model) {
//
//      log.info("/get or modify ");
//      model.addAttribute("board", service.get(bno));
//   }
   
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {

		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}


   // p.219
   @PostMapping("/modify")
   public String modify(BoardVO board, RedirectAttributes rttr) {
      log.info("modify:" + board);

      // ?error
      // ?success
      // ?result=success
      if (service.modify(board)) {
         rttr.addFlashAttribute("result", "success");
      }
      return "redirect:/board/list";
   }

   // p.220
   @PostMapping("/remove")
   public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr)
   {

      log.info("remove..." + bno);
      if (service.remove(bno)) {
         rttr.addFlashAttribute("result", "success");
      }
      return "redirect:/board/list";
   }
} // class














