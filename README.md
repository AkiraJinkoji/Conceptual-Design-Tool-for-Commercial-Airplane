# Conceptual-Design-Tool-for-Commercial-Airplane

## 1. Context / Introduction
This project develops a **conceptual design tool** for **fixed-wing commercial aircraft**, in Matlab. The tool implements a **Sizing and Synthesis framework**, coupling **mission analysis** and **constraint analysis** to generate key design parameters and visualize tradeoffs in performance.  It was completed in the context of class project of **AE6343 - Aircraft Design 1**.

As a benchmark, the **Airbus A320neo** is used to validate the approach. While results deviate from real-world data due to simplified assumptions, the tool successfully demonstrates how conceptual design decisions can be automated and iteratively refined.

---

## 2. Problem Description
The preliminary design of an aircraft requires translating **mission requirements** (range, payload, crew, endurance) and **operational constraints** (takeoff distance, climb rate, stall margin) into **aircraft characteristics** such as:
- Takeoff gross weight  
- Wing surface area  
- Static thrust at sea level  
- Fuel and empty weight fractions  

Traditional methods rely heavily on historical data and manual iteration. This tool automates the process, providing systematic convergence and visualizations to guide early-stage aircraft design.

---

## 3. Method
The tool works through two coupled analyses:  

### Mission Analysis
- Estimates weight fractions for each phase (takeoff, climb, cruise, loiter, descent, approach, landing).  
- Uses Breguet’s range and endurance equations, generic fuel burn integration, and Mattingly’s TSFC relation.  
- Iteratively solves for takeoff, empty, and fuel weights.  

### Constraint Analysis
- Derives thrust-loading (T/W) vs. wing-loading (W/S) requirements for each phase.  
- Identifies the feasible design space and selects the design point minimizing thrust loading.  

**Outputs** include numerical values (weights, thrust, wing area) and plots (weight breakdown, mission evolution, constraint curves).

---

## 4. Repository Map (How to Use)
<pre>

Matlab_code/                          # Main source code folder
├── Input.m                           # Entry point – define mission, constraints, parameters
├── MissionProfile.m                  # Class to define mission phases and parameters
├── AdditionalConstraints.m           # Class to define additional performance constraints
├── other_input_parameters.m          # Struct to hold payload, crew, and initial guesses
├── CA_MA_iteration.m                 # Main iterative loop for constraint and mission analysis
├── constraints_plots.m               # Generates T/W vs W/S constraint curves
├── air_condition.m                   # Atmospheric model (ISA-based lookup)
├── convert_KEAS2KTAS.m               # Converts calibrated to true airspeed
├── convert_nautical_miles2feet.m     # Converts nautical miles to feet
├── calculate_*.m                     # compute parameters value given their formulas
│  ├── calculate_TSFC.m                  # Computes thrust-specific fuel consumption
│  ├── calculate_CD0.m                   # Zero-lift drag coefficient estimation
│  ├── calculate_alpha.m                 # Engine lapse rate calculation
│  ├── calculate_EWF.m                   # Empty weight fraction estimation
│  ├── calculate_FWF.m                   # Fuel weight fraction estimation
│  ├── calculate_wf2wi_breguet_range.m   # Breguet range equation
│  └── calculate_wf2wi_breguet_endurance.m # Breguet endurance equation
├── master_equation.m                 # Core equation realting thrust loading and wing loading ratios for constraint analysis
├── constraint_*.m                    # Constraint models
│   ├── constraint_service_ceiling.m
│   ├── constraint_max_mach.m
│   ├── constraint_approach.m
│   ├── constraint_steep_turn.m
│   └── constraint_engine_inoperative_takeoff.m
├── phase_*.m                         # Mission phase models
│   ├── phase_cruise.m
│   ├── phase_constant_speed_climb.m
│   ├── phase_descent.m
│   ├── phase_decelerate.m
│   ├── phase_horizontal_acceleration.m
│   ├── phase_approach.m
│   ├── phase_loiter.m
│   ├── phase_landing.m
│   ├── phase_takeoff.m
│   ├── phase_takeoff2_high_thrust.m
│   └── phase_taxi_inout.m
└── inverse_air_condition.m           # Inverse atmospheric lookup
</pre>

### Running the Tool
1. Unzip `Matlab_programs_to_submit`.  
2. Open `Inputs.m` in MATLAB.  
3. Define:
   - Mission profile (phases, type, parameters)  
   - Additional constraints  
   - Initial guesses (takeoff weight, wing area, static thrust)  
   - Payload and crew weights  
   - Max iterations (default = 10)  
4. Run the script.  

---

## 5. Input / Output Interpretation

### Inputs
- **Mission profile**: sequence of flight phases + parameters  
- **Constraints**: operational/airworthiness limits  
- **Initial guesses**: takeoff weight, wing surface, thrust  
- **Payload/crew weights**  
- **Iterations**: maximum allowed  

Note: *Phase names must be spelled correctly for the tool to work.*

### Outputs
- Numerical results in MATLAB command window:
  - Thrust loading (T/W), Wing loading (W/S)  
  - Takeoff weight, Empty weight, Fuel weight  
  - Wing surface, Static thrust at sea level  
- Visualization plots:
  - Weight breakdown (empty, fuel, payload, crew)  
  - Weight fraction evolution across mission phases  
  - Constraint plots with feasible region and chosen design point  

---

## 6. References
- Mattingly, J. D., *Aircraft Engine Design*, AIAA, 2000.  
- Mattingly, J. D., *Altitude Tables*, AIAA Education Series, 2024.  
- Jenkinson, L., Simpkin, P., Rhode, D., *Civil Jet Aircraft Design*, Butterworth-Heinemann.  
