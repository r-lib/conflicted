# can register preference for multiple functions

    Code
      conflict_prefer_all("funmatch")
    Message
      [conflicted] Will prefer `funmatch::mean()` over any other package.
      [conflicted] Will prefer `funmatch::pi()` over any other package.

---

    Code
      conflict_prefer("mean", "funmatch", "noodle")
    Message
      [conflicted] Will prefer `funmatch::mean()` over `noodle::mean()`.
    Code
      conflict_prefer("mean", "funmatch", "boodle")
    Message
      [conflicted] Removing existing preference.
      [conflicted] Will prefer `funmatch::mean()` over `boodle::mean()`.

---

    Code
      conflict_prefer_matching("m", "funmatch")
    Message
      [conflicted] Will prefer `funmatch::mean()` over any other package.

