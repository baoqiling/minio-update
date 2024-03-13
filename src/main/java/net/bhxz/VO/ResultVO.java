package net.bhxz.VO;

import io.swagger.annotations.ApiModelProperty;
import lombok.Builder;
import lombok.Data;

/**
* @author dragon-w 289015374@qq.com
* 2018/6/22 上午11:59
 * 接口请求返回的最外层对象
*/

@Builder
@Data
public class ResultVO<T> {


    @ApiModelProperty(value = "返回状态码,200成功，400失败")
    private int code;

    @ApiModelProperty(value = "接口描述信息")
    private String message;

    @ApiModelProperty(value = "返回结果")
    private T data;

    public ResultVO() {
    }


    public ResultVO(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public ResultVO(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }
}