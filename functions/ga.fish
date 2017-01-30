set -g -x arr ""

function __git_add -a var
    # is numeric 
    if [ "$var" -eq "$var" ] 2>/dev/null
        # number
        set myarg $arr[$var]

        # -- (hyphen hyphen) compare
        set hyphen (printf "%b" (printf '%s%x' '\x' 45))
        if [ "$myarg" = "$hyphen$hyphen" ] 2>/dev/null
            set myarg './'$myarg 
        end

        git add $myarg
    else
        # not a number
        git add $var
    end
end

function __ga
    # number
    set res (string split "-" -- (string trim $argv))
    set first $res[1]
    set length (count $res)
    set last ""

    # >
    if [ $length -gt 1 ]
        set last $res[2]
    # >
    else
        # just one
        __git_add $res
        return
    end

    # last exists
    if [ $last != '' ]
        set arr_length (count $arr)

        # clamp as array length
        if [ $arr_length -lt $last ]
          set last $arr_length 
        end

        # first < last
        if [ $first -lt $last ]
          for i in (seq $first 1 $last)
              __git_add $i
          end
        else
          echo 'Argument is not valid.'
        end
    else
        __git_add $first
    end
end

function ga
    # space like, `ga 1 2 3`
    set res (string split " " -- (string trim $argv))
    set length (count $res)

    # only one
    if [ $length -eq 0 ]
        __ga $argv
        return
    end

    for i in $res
        #echo $i
        __ga $i
    end
end
