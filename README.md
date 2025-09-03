# Conceptual-Design-Tool-for-Commercial-Airplane

## 1. Context / Introduction
This project develops a **conceptual design tool** for **fixed-wing commercial aircraft**. The tool implements a **Sizing and Synthesis framework**, coupling **mission analysis** and **constraint analysis** to generate key design parameters and visualize tradeoffs in performance.  It was completed in the context of class project of **AE6343 - Aircraft Design 1**.

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
Matlab_programs_to_submit/ # Main source code folder
├── Inputs.m # Entry point – define mission, constraints, parameters
├── ... (other scripts) # Iterative mission and constraint analysis routines
Reports/ # Documentation & project reports

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

⚠️ *Phase names must be spelled correctly for the tool to work.*

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
