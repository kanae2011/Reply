package org.zerock.board.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyVO {

	private Long rno; 
	private Long no;
	
	private String content;
	private String writer;
	
	private Date writeDate;
	private String pw;
}
