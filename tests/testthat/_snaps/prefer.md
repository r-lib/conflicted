# useful messages for specific preferences

    Code
      conflict_prefer("mean", "canoodle", c("noodle", "doodle"))
    Message
      [conflicted] Will prefer canoodle::mean over noodle::mean and doodle::mean.
    Code
      conflict_prefer("mean", "canoodle", "boodle")
    Message
      [conflicted] Removing existing preference.
      [conflicted] Will prefer canoodle::mean over boodle::mean.
    Code
      conflict_prefer("+", "canoodle")
    Message
      [conflicted] Will prefer canoodle::`+` over any other package.

# can register preference for multiple functions

    Code
      conflict_prefer_all("funmatch")
    Message
      [conflicted] Will prefer funmatch::median over any other package.
      [conflicted] Will prefer funmatch::pi over any other package.

---

    Code
      conflict_prefer_all("funmatch", "base")
    Message
      [conflicted] Will prefer funmatch::pi over base::pi.

---

    Code
      conflict_prefer_matching("m", "funmatch")
    Message
      [conflicted] Will prefer funmatch::median over any other package.

