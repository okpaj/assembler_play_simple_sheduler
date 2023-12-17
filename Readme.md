Continuing learning ARM Cortex-M4 architecture.
Now I'm making round-robin scheduler/switcher in C/assembly.

What learned:
1 what AAPCS works, and how exceptions stack registers.
2 constructing fake stack for first run of stuck
--working of stm and ldm instructions  

Plan of scheduler:
Prepare "fake" stack of tasks for first run.
Use process stack in thread mode and main in handler mode (bit spsel in control reg.).

Sys_Tick handler chooses next task and calls switcher (PendSV handler)



Switcher:
	stack preempted task registers r4-r11 (using current psp it knows where to put them and
		no need to pass to switcher old task)
	change psp to new value, unstack new task r4-r11 register
	