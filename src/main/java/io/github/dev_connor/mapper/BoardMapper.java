package io.github.dev_connor.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import io.github.dev_connor.domain.BoardVO;
import io.github.dev_connor.domain.Criteria;

public interface BoardMapper {
	public List<BoardVO> getList();
	public void insert(BoardVO board);
	public void insertSelectKey(BoardVO board);
	public BoardVO read(Long bno); // p 193
	public int delete(Long bno);   // p 194
	public int update(BoardVO board); // p 196
	public List<BoardVO> getListWithPaging(Criteria cri); // p 294
	public int getTotalCount(Criteria cri); // p 322
}
