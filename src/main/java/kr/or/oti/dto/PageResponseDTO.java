package kr.or.oti.dto;

import java.util.List;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageResponseDTO<E> {

	private int page;
	private int size;
	private int total;
	
	private int start;
	private int end;
	
	private boolean prev;
	private boolean next;
	
	private List<E> dtoList;

	
	public PageResponseDTO(PageRequestDTO pageRequestDTO, List<E> dtoList, int total){
				
		this.page = pageRequestDTO.getPage();
		this.size = pageRequestDTO.getSize();
		this.total = total;
		this.dtoList = dtoList;
		
		this.end = (int)Math.ceil(page/10.0)*10;
		this.start = end - 9;
		
		int last = (int)Math.ceil(total/(double)size);
		
		if(end > last) {
			end = last;
		}
		
		this.prev = start > 1;
		this.next = end < last;
	}
}
