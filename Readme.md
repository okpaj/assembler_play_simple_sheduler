Continuing learning ARM Cortex-M4 architecture.
Now I'm making round-robin scheduler/switcher in C/assembly.

Running it on so called BlackPile with STM32F401CE

Two diodes connected to PA0 and PA2.
PA0 - ticks on entry to SysTick handler (it is just for visual
 checking that it is not stuck in any fault handler)
PA2 - one task turns it off, the other turns it on. (ticking freq as PA0)



What learned:
1 what AAPCS works, and how exceptions stack registers.
2 constructing fake stack for first run of stuck
3 exceptions workings

Plan of scheduler:
Stacks for tasks it is just array.
Prepare "fake" stacks of tasks for first run.
Setting psp to first task prepared stack
Enabling using psp in thred mode is done by SVC handler (proper lr value)
Next "scheduling" next task in Sys Tick handler and setting PendSV exception
In PendSV handler is done stacking/unstaking of preempted/selected task 
and on exit from the exception selected task is run.


Switcher:
	stack preempted task registers r4-r11 (using current psp it knows where to put them and
		no need to pass to switcher old task)
	change psp to new value, unstack new task r4-r11 register


What to do:
maybe some cleaning and reorganising - it is all in one main file
	