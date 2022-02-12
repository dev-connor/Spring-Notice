package io.github.dev_connor.domain;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
public class BoardVO {
	private long bno;
	private String title; 
	private String content;
	private String writer;
	private Date regdate; 
	private Date updateDate;
}
