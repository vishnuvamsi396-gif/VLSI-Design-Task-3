# Assertions

## Executable immediate assertions

`assertions/design_assertions.sv` provides Icarus-friendly sampled checks for counter range and wrap-after-maximum, legal traffic-light states, reset values, clock-edge synchronization, and known ALU results. The testbenches use immediate `assert` statements for expected outputs and call `$fatal` on mismatches.

Assertions are monitors, not a substitute for test stimulus. A failing check prints the sampled value and terminates the simulation. The traffic FSM monitor samples on the falling edge so the state updated by the preceding rising edge is stable.

## Concurrent assertion concept

For a simulator with concurrent SVA support, properties can express cycle relationships. Example (illustrative, not included in the default Icarus build):

```systemverilog
property p_sync_reset_clears_register;
  @(posedge clk) reset |=> (q == '0);
endproperty
assert property (p_sync_reset_clears_register);
```

This states that after a sampled synchronous reset, the register is zero at the next sampled clock. Icarus support for concurrent properties depends on build/version; the checked-in default suite therefore uses immediate assertions and does not report concurrent-SVA execution as completed.
