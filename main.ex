defmodule Palin do
    def main() do
        case IO.gets "" do
            :eof -> IO.puts "error: eof"
            {:error, reason} -> IO.puts "error: " <> reason
            some -> case Integer.parse( some) do
                    :error -> IO.puts "wrong int"
                    {count, _} -> readLine count
                end
        end
    end
    def readLine(count) when is_integer(count) do
        cond do
            count == 0 -> :ok
            true -> 
                str = IO.gets ""
                newstr = String.slice(str, 0, String.length(str) - 1)
                palin = getNextPalindrome newstr
                IO.puts palin
                readLine (count - 1)
        end
    end
    def getNextPalindrome(line) do
        len = String.length(line)
        cond do
            len < 2 || (len == 2 && line == "10") -> "11"
            true ->
                half  = div(len, 2)
                center_len = rem(len,2)

                left = String.slice(line, 0, half)
                right = String.slice(line, half+center_len, half)
                center = String.slice(line,half, center_len)
                rleft = String.reverse( left)
                if rleft > right do left <> center <> rleft
                else
                    next_left_center = incString (left <> center)
                    next_left_center_len = String.length next_left_center
                    {next_left_len, next_center_len} = if next_left_center_len > half + center_len do
                            cond do
                                center_len == 0 -> {half, 1}
                                true -> {half+1, 0}
                            end
                        else
                            {half, center_len}
                        end
                    next_left = String.slice(next_left_center, 0, next_left_len)
                    next_center = String.slice(next_left_center, next_left_len, next_center_len)

                    next_left <> next_center <> String.reverse(next_left)
                end
       end 
    end
    def incString(line) do
        List.to_string(incStringWorker(String.to_char_list(line), [], true,String.length(line)))
    end
    def incStringWorker(_line, tmp, stillinc, index)when index == 0 do
        if stillinc do ['1'|tmp]
        else
            tmp
        end
    end
    def incStringWorker(line, tmp, stillinc, index) when stillinc == true do 
        {newchar, newstillinc} = if stillinc == false do
                {Enum.at(line, index - 1), false}
            else
                mchr = Enum.at(line, index - 1)
                    if mchr == 57 do {'0', true}
                    else
                        {mchr+1, false}
                    end
            end
        incStringWorker(line, [newchar | tmp], newstillinc, (index - 1))
    end
    def incStringWorker(line, tmp, stillinc, index) do
        newchar = Enum.at(line, index - 1)
        incStringWorker(line, [newchar|tmp], stillinc, index - 1)
    end
end
Palin.main
