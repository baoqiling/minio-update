package net.bhxz.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/***
 * @ClassName WeatherMessage
 * @author baoqiling
 * @version 1.0.0
 * @Description
 * @createTime 2024/3/19 9:55 
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class WeatherMessage {

    private String msgtype;
    private TextContent text;

}
