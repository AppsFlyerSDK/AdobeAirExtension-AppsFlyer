/**
 * Created by Maksym on 11.07.2017.
 */
package {
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class UIUtils {

    public static function createTextField(dimensions:Rectangle, ediatble:Boolean, size:Number):TextField {
        var field:TextField = new TextField();
        var tf:TextFormat = field.defaultTextFormat;
        tf.size = size;
        tf.align = TextFormatAlign.CENTER;
        field.setTextFormat(tf);
        field.textColor = 0x000000;
        field.type = ediatble ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
        field.selectable = ediatble;
        field.mouseEnabled = ediatble;

        field.x = dimensions.x;
        field.y = dimensions.y;
        field.width = dimensions.width;
        field.height = dimensions.height;

        return field;
    }

    public static function createButton(label:String, size:Number):Sprite {
        var s:Sprite = new Sprite();
        s.graphics.lineStyle(1, 0x0000FF);
        s.graphics.beginFill(0x222222, 1);
        s.graphics.drawRoundRect(0, 0, 70, 25, 7, 7);
        s.graphics.endFill();

        var t:TextField = new TextField();
        t.text = label;

        var tf:TextFormat = t.defaultTextFormat;
        tf.size = size;
        tf.font = "Helvetica";
        tf.align = TextFormatAlign.CENTER;
        t.setTextFormat(tf);

        t.textColor = 0xFFFFFF;
        t.selectable = false;
        t.mouseEnabled = false;
        t.width = s.width * 0.95;
        t.height = s.height;
        t.x = (s.width * 0.020);
        t.y = (s.height * 0.5) - (t.textHeight * 0.5);

        s.addChild(t);

        return s;
    }
}
}
