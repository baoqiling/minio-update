package net.bhxz.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/***
 * @ClassName TextContent
 * @author baoqiling
 * @version 1.0.0
 * @Description
 * @createTime 2024/3/19 9:52 
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class TextContent {
    private String content;
    private List<String> mentioned_list;
    private List<String> mentioned_mobile_list;
}
