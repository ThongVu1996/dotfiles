# **🚀 VIM CHEATSHEET: NATURAL THINKING**

"Don't memorize by rote; remember through Mnemonics and Logic."

This guide summarizes Vim shortcuts based on visual and logical patterns (Mnemonics) to help you develop natural muscle memory.

## **1. Basic Navigation**

| Key | Action | Mnemonic |
| :--- | :-------- | :-------------------------------------------- |
| h    | Left      | Index finger (left side).                     |
| j    | Down      | The shape of 'j' hooks downward.              |
| k    | Up        | 'k' for King (on top) / Upward shape.         |
| l    | Right     | Pinky finger (right side).                    |

## **2. Line Motion**

_Rules: Visual Metaphors & Regex_

| Key   | Action                             | Mnemonic                                                                 |
| :---- | :--------------------------------- | :----------------------------------------------------------------------- |
| **^** | To **start of line** (non-blank)   | Arrow pointing up to the start. (Regex start).                          |
| **$** | To **end of line**                 | **Money ($)** is always at the end after payment. (Regex end).           |
| **%** | Jump between matching (), {}, []   | Two circles at ends of % represent a **pair**. Use for debugging braces. |

## **3. Word Motion (word vs WORD)**

_Rule: Size matters (Lowercase = Small/Sensitive, Uppercase = Big/Aggressive)_

| Key   | Action                        | Mnemonic                                                      |
| :---- | :---------------------------- | :------------------------------------------------------------ |
| **w** | Next **word** start           | **w**ord (small). Stopped by dots, commas, etc.               |
| **W** | Next **WORD** start           | **W**HOLE word (big). Only stops at **Whitespace (Space)**.   |
| **b** | Previous **word** start       | **b**ack (small). Stopped by special characters.              |
| **B** | Previous **WORD** start       | **B**ACK through everything, only stops at Space.             |
| **e** | To **word** end               | **e**nd (small). Stops just before punctuation.               |
| **E** | To **WORD** end               | **E**ND (big). Jumps through punctuation to word end.         |

## **4. Scrolling & Blocks**

| Key           | Action                          | Mnemonic                                                      |
| :------------ | :------------------------------ | :------------------------------------------------------------ |
| **Ctrl + u** | Up half a page                  | **U**p.                                                       |
| **Ctrl + d** | Down half a page                | **D**own.                                                     |
| **Ctrl + f** | Forward full page               | **F**orward (Flip page forward).                              |
| **Ctrl + b** | Backward full page              | **B**ackward (Flip page backward).                            |
| **Ctrl + e** | Scroll down 1 line (keep cursor)| **E**xpose (Show more lines at bottom) or **E**xtra lines.    |
| **Ctrl + y** | Scroll up 1 line (keep cursor)  | **Y**oyo (Pull up). 'Y' is on the top row, pulls view up.     |
| **{**         | Previous paragraph              | Jump to empty line above (Start of code block {).             |
| **}**         | Next paragraph                  | Jump to empty line below (End of code block }).               |

## **5. Bracket Jumping (Structured Navigation)**

_Rule: **[** is Back/Previous, **]** is Forward/Next. Second character is the target._

| Key     | Action                             | Mnemonic                                                                        |
| :------ | :--------------------------------- | :------------------------------------------------------------------------------ |
| **[{**  | Jump to start of surrounding {     | **[** (Back) to **{** (start of function/block). Useful for finding function name.|
| **]}**  | Jump to end of surrounding }       | **]** (Next) to **}** (end of function/block).                                  |
| **[(**  | Jump to previous unclosed (        | **[** (Back) to **(** (start of expression).                                     |
| **])**  | Jump to next unclosed )            | **]** (Next) to **)** (end of expression).                                       |

## **6. Time Travel (Navigation History)**

_Rule: Similar to Back/Forward buttons in a web browser._

| Key           | Action                   | Mnemonic                                       |
| :------------ | :----------------------- | :--------------------------------------------- |
| **Ctrl + o** | Go to previous position  | **O**ld positions.                             |
| **Ctrl + i** | Go to newer position     | Opposite of 'o'. Or **I**n front.              |

## **7. Editing Language (Operators) - CRITICAL**

_Mindset: **Verb (Operator)** + **Noun (Motion/Object)** = Command._

| Key   | Meaning (Verb)        | Practical Use & Mnemonic                                                      |
| :---- | :-------------------- | :---------------------------------------------------------------------------- |
| **d** | **D**elete            | Cuts text into clipboard (can be pasted).                                     |
| **c** | **C**hange            | **Delete + Enter Insert Mode**. Use when replacing something with new text.   |
| **y** | **Y**ank              | Copy (Yank sounds like pulling something out to keep it).                     |
| **p** | **P**ut               | Paste (Put content after cursor).                                             |

### **Text Objects: "Inner" vs "Around"**

_The pinnacle of Vim: Targeting structure instead of counting characters._

- **i** = **I**nner: Only content, NOT the delimiters.
- **a** = **A**round: Content AND the delimiters.

| Combo   | Meaning                        | Logic / Practical Use                                           |
| :------ | :----------------------------- | :-------------------------------------------------------------- |
| **di(** | **D**elete **I**nner **(**     | Deletes everything **inside** (), keeps parentheses.            |
| **ci(** | **C**hange **I**nner **(**     | Deletes inside () and starts typing immediately. (High use).   |
| **da(** | **D**elete **A**round **(**    | Deletes **the whole unit** including parentheses.               |
| **ci"** | **C**hange **I**nner **"**     | Change contents within double quotes "...".                     |
| **yi{** | **Y**ank **I**nner **{**       | Copy everything inside a code block {...}.                      |
| **daw** | **D**elete **A**round **W**ord | Delete word and the trailing space (clean text).                |

### **The Power of Dot . (The Dot)**

The ultimate weapon for speeding up repetitive edits.

| Key   | Action                             | Mindset / Workflow                                           |
| :---- | :--------------------------------- | :----------------------------------------------------------- |
| **.** | Repeat last modification           | "Whatever I just did, do **exactly** that again here."     |

**Workflow Example:**

1. Delete a word: Type `dw`.
2. Move to next garbage word: `w`, `j`, etc.
3. Want to delete it? Don't type `dw`. Just type **`.`**.
4. Move again -> Type **`.`** -> Move again -> Type **`.`**.

## **8. Zoning & Vision (Z-Commands)**

_Rule: **Z**one (View) & Zoom_

| Key    | Action                                   | Mnemonic                                                       |
| :----- | :--------------------------------------- | :------------------------------------------------------------- |
| **zz** | Center current line on screen            | **Z**one **Z**ero (Center). Or "zz" sleeping (head drops mid). |
| **zt** | Move current line to **Top** of screen   | **Z**one **T**op.                                              |
| **zb** | Move current line to **Bottom** of screen| **Z**one **B**ottom.                                           |
| **zh** | Scroll screen to the **Left**            | Hold 'z' + direction 'h'. Useful when wrap-text is off.        |
| **zl** | Scroll screen to the **Right**           | Hold 'z' + direction 'l'.                                      |
| **zm** | Fold **More** (close folds)               | Fold **M**ore.                                                 |
| **zr** | **R**educe folding (open folds)           | **R**educe folding.                                            |

## **9. Inline Search**

_Rule: The triad combo of f - ; - ,_

| Key           | Action                   | Mnemonic                                       |
| :------------ | :----------------------- | :--------------------------------------------- |
| **f** + char  | Find next 'char'         | **F**ind.                                      |
| **;**         | Repeat 'f' (next)        | Right pinky -> Natural forward motion.         |
| **,**         | Repeat 'f' (previous)    | Comma looks like a reverse hook -> Go back.   |

## **10. Special Commands**

| Key   | Action                                     | Mnemonic                                                     |
| :---- | :----------------------------------------- | :----------------------------------------------------------- |
| **&** | Repeat last **Substitute** (:s) command    | **Ampersand** = **AND**. _"Do what I did to the line above AND (&) this one."_|

### **💡 Update Training Roadmap**

1. **Week 1:** Master `w/W` + `Ctrl-u/d`.
2. **Week 2:** Master `^/$` + `zz` + `Ctrl+o/i` (Jump and return).
3. **Week 3:** Master `dw`, `cw` combined with the `.` dot (Crucial for speed).
4. **Week 4:** Master `f/;/`, + `ci(`, `di{` (Structural Editing).
