function __myc_timestamp
  # set_color $fish_color_autosuggestion 2> /dev/null; or set_color 555
  # set_color 62A
  set_color c03fd9
  echo -n (date "+%H:%M:%S" | tr -d '\n')
  echo -n " "
  set_color normal
end

function __myc_user
  if test "$prompt_two_lines" = "yes"
    set_color green
    echo -n $USER
    set_color normal
    echo -n "@"
    set_color yellow
    echo -n (prompt_hostname)
    echo -n " "
  end
end

function __myc_kube
  set -l ctx (kubectl config current-context 2>/dev/null)
  if test $status -ne 0
    set -l ctx "n/a"
  end

  set -l ns (kubectl config view --minify -o 'jsonpath={..namespace}' 2>/dev/null)
  if test $status -ne 0
    set -l ns "n/a"
  end

  set_color FF5733
  echo -n "k8s:$ctx:$ns "

  set_color normal
end

function __myc_aws
  if test -n "$AWS_PROFILE"
    set_color c03fd9
    echo -n "aws:$AWS_PROFILE region:$AWS_DEFAULT_REGION "
    set_color normal
  end
end

function __myc_pwd
  set -l ppwd (prompt_pwd)
  if test "$prompt_two_lines" = "yes"
    set ppwd (pwd)
  end

  set -l dname (dirname $ppwd)
  set -l bname (basename $ppwd)

  if [ $dname != "." ]
    set_color brblue
    echo -n "$dname"
    set -l last (string sub -s -1 -l 1 $dname)
    if [ "$last" != "/" ]
      echo -n "/"
    end
  end

  if [ $bname != "/" ]
    set_color cyan
    echo -n $bname
  end

  echo -n " "

  if [ "$prompt_two_lines" = "yes" ]
    echo
  end
end

function __myc_vcs_touched
  if type -q vcs.touched && vcs.touched ; echo -n "yes"; else; echo -n "no"; end
end

function __myc_vcs_dirty
  if type -q vcs.dirty && vcs.dirty; echo -n "yes"; else; echo -n "no"; end
end

function __myc_vcs_staged
  if type -q vcs.staged && vcs.staged; echo -n "yes"; else; echo -n "no"; end
end

function __myc_vcs_state
  set -l state (vcs.status)

  if [ "$state" = "" ]
    echo -n "local"
  else
    echo -n "$state"
  end
end

function __myc_vcs_statuses -a touched dirty staged
  set -q theme_vcs_symbol_touched; or set -l theme_vcs_symbol_touched "…"
  set -q theme_vcs_symbol_dirty; or set -l theme_vcs_symbol_dirty "○"
  set -q theme_vcs_symbol_staged; or set -l theme_vcs_symbol_staged "●"
  set -q theme_vcs_symbol_dirty_staged; or set -l theme_vcs_symbol_dirty_staged "◉"

  if [ $touched = "yes" ]; and [ $dirty = "no" ]; and [ $staged = "no" ]
    echo -n "$theme_vcs_symbol_touched"
  end

  if [ $dirty = "yes" ]; and [ $staged = "yes" ]
    echo -n "$theme_vcs_symbol_dirty_staged"
  else if [ $dirty = "yes" ]
    echo -n "$theme_vcs_symbol_dirty"
  else if [ $staged = "yes" ]
    echo -n "$theme_vcs_symbol_staged"
  end
end

function __myc_vcs_branch -a state touched branch
  set -l s ""

  if [ $touched = "yes" ]
    set_color yellow
  else
    set_color green
  end

  set -q theme_vcs_symbol_ahead; or set -l theme_vcs_symbol_ahead "+"
  set -q theme_vcs_symbol_behind; or set -l theme_vcs_symbol_behind "-"
  set -q theme_vcs_symbol_diverged; or set -l theme_vcs_symbol_diverged "±"
  set -q theme_vcs_symbol_local; or set -l theme_vcs_symbol_local "*"

  switch "$state"
    case "ahead"
      set s "$theme_vcs_symbol_ahead"
    case "behind"
      set s "$theme_vcs_symbol_behind"
    case "diverged"
      set s "$theme_vcs_symbol_diverged"
    case "local"
      set s "$theme_vcs_symbol_local"
    case "detached"
      set_color red
  end

  echo -ns $branch $s
end

function __myc_vcs
  if vcs.present
    set -l vcs_touched (__myc_vcs_touched)
    set -l vcs_dirty (__myc_vcs_dirty)
    set -l vcs_staged (__myc_vcs_staged)
    set -l vcs_status (vcs.status)
    set -l vcs_state (__myc_vcs_state)

    set -l vcs_branch (vcs.branch)

    set -l branch (__myc_vcs_branch $vcs_state $vcs_touched $vcs_branch)
    set -l statuses (__myc_vcs_statuses $vcs_touched $vcs_dirty $vcs_staged)

    set_color normal
    echo -n "("
    echo -n "$branch"
    if [ "$statuses" != "" ]
      set_color blue
      echo -n " $statuses"
    end
    set_color normal
    echo -n ") "
  end
end

function __myc_prompt
  set_color normal
  echo -n "> "
end

function __myc_status -a last_status
  if [ $last_status != 0 ]
    set_color red
    # set_color brgreen
    echo -n "status:$last_status "
    set_color normal
  end
end

function fish_prompt
  set -l last_status $status

  if test "$prompt_two_lines" = "yes"
    __myc_timestamp
  end
  __myc_status $last_status
  __myc_user
  if test "$prompt_two_lines" = "yes"
    __myc_kube
  end
  if test "$prompt_show_ctx" = "yes"; or test "$prompt_show_ctx_force" = "yes"
    __myc_aws
  end
  __myc_pwd
  __myc_vcs
  __myc_prompt

  set_color normal
end

function postexec_test --on-event fish_postexec
  if [ "$prompt_two_lines" = "yes" ]
    echo
  end
end

function fish_right_prompt
#  if test "$prompt_two_lines" = "no"
#    __myc_timestamp
#  end
end

set prompt_show_ctx no
set prompt_show_ctx_force no
set fish_color_command brblue
