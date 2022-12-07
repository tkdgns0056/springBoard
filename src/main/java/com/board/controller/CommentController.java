package com.board.controller;

import com.board.domain.CommentDto;
import com.board.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

//@Controller
//@ResponseBody
@RestController
public class CommentController {

    @Autowired
    CommentService commentService;

    //댓글 수정 메서드
    @PatchMapping("/comments/{cno}")
    //@ResponseBody
    public ResponseEntity<String> modify(@PathVariable Integer cno, @RequestBody CommentDto dto, HttpSession session){
        String commenter = "asdf";
        dto.setCommenter(commenter);
        dto.setCno(cno);
        System.out.println("dto = " + dto);

        try {
            if(commentService.modify(dto)!=1){
                throw new Exception("Modify failed.");
            }
            return new ResponseEntity<>("MOD_OK", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<String>("MOD_ERR", HttpStatus.BAD_REQUEST);
        }
    }

    //댓글 저장 메서드
    @PostMapping("/comments")
    //@ResponseBody
    public ResponseEntity<String> writer(@RequestBody CommentDto dto, Integer bno ,HttpSession session){
        // 작성자는 session으로  가져온다.
        //String commenter = (String)session.getAttribute("id");
        String commenter = "asdf";
        dto.setCommenter(commenter);
        dto.setBno(bno);
        System.out.println("dto = " + dto);

        try {
            if(commentService.write(dto)!=1){
                throw new Exception("Write failed.");
            }
            return new ResponseEntity<>("WRT_OK", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<String>("WRT_ERR", HttpStatus.BAD_REQUEST);
        }
    }

    // 지정된 댓글을 삭제하는 메서드
    @DeleteMapping("/comments/{cno}")
    //@ResponseBody
    public ResponseEntity<String> remove(@PathVariable Integer cno, Integer bno, HttpSession session){

        // 작성자는 session으로  가져온다.
        //String commenter = (String)session.getAttribute("id");
          String commenter = "asdf";

        try {
            int rowCnt = commentService.remove(cno, bno, commenter);

            if(rowCnt != 1){
                throw  new Exception("Delete Failed");
            }
            return new ResponseEntity<>("DEL_OK", HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("DEL_ERR", HttpStatus.BAD_REQUEST);
        }
    }


    //지정된 게시물의 모든 댓글을 가져오는 메서드
    @GetMapping("/comments")
    //@ResponseBody
    public ResponseEntity<List<CommentDto>> list(Integer bno){

        List<CommentDto> list = null;
        try {
          list = commentService.getList(bno);
            System.out.println("list = " + list);
            return new ResponseEntity<List<CommentDto>>(list, HttpStatus.OK);
        } catch (Exception e) {
           e.printStackTrace();
        }
        return new ResponseEntity<List<CommentDto>>(list, HttpStatus.BAD_REQUEST);
    }
}
