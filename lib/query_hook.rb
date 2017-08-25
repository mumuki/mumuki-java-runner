class JavaQueryHook < JavaFileHook
  def command_line(filename)
    "runquery #{filename}"
  end

  def compile_file_content(req)
    <<EOF
import java.util.*;
import java.util.function.*;
import java.util.stream.*;
import java.util.stream.Collectors.*;
import java.time.*;

#{req.content}
#{req.extra}

public class Query {
  public static void main(String[] args) {
    System.out.println("=> " + String.valueOf(#{req.query}));
  }
}
EOF
  end
end
