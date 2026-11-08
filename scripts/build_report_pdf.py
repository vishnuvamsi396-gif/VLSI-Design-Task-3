#!/usr/bin/env python3
"""Build the Task 3 project report PDF from the verified project status."""
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, Image
)

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "task3_project_report.pdf"
NAVY = colors.HexColor("#17365D")
BLUE = colors.HexColor("#4472C4")
PALE = colors.HexColor("#EAF2F8")


def draw_page(canvas, doc):
    canvas.saveState()
    w, h = letter
    canvas.setStrokeColor(colors.HexColor("#D9E2F3"))
    canvas.line(doc.leftMargin, 0.55 * inch, w - doc.rightMargin, 0.55 * inch)
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#5B6573"))
    canvas.drawString(doc.leftMargin, 0.36 * inch, "VLSI Design and Semiconductor Engineering - Task 3")
    canvas.drawRightString(w - doc.rightMargin, 0.36 * inch, f"Page {doc.page}")
    canvas.restoreState()


styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name="TitleTask", parent=styles["Title"], fontName="Helvetica-Bold",
                          fontSize=23, leading=28, textColor=NAVY, alignment=TA_CENTER, spaceAfter=9))
styles.add(ParagraphStyle(name="SubtitleTask", parent=styles["Normal"], fontSize=11, leading=16,
                          alignment=TA_CENTER, textColor=colors.HexColor("#4F5B66"), spaceAfter=18))
styles.add(ParagraphStyle(name="H1Task", parent=styles["Heading1"], fontSize=16, leading=20,
                          textColor=NAVY, spaceBefore=10, spaceAfter=7))
styles.add(ParagraphStyle(name="H2Task", parent=styles["Heading2"], fontSize=12, leading=15,
                          textColor=BLUE, spaceBefore=7, spaceAfter=4))
styles.add(ParagraphStyle(name="BodyTask", parent=styles["BodyText"], fontSize=9.5, leading=13,
                          spaceAfter=6))
styles.add(ParagraphStyle(name="SmallTask", parent=styles["BodyText"], fontSize=8.2, leading=10.5))


def P(text, style="BodyTask"):
    return Paragraph(text, styles[style])


def make_table(rows, widths):
    t = Table([[P(str(cell), "SmallTask") for cell in row] for row in rows], colWidths=widths, repeatRows=1)
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), NAVY),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("BACKGROUND", (0, 1), (-1, -1), colors.white),
        ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#CFD8E3")),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
    ]))
    return t


story = [
    Spacer(1, 0.45 * inch),
    P("Task 3 Project Report", "TitleTask"),
    P("RTL Verification, SystemVerilog, Memory Design, and a Parameterized ALU", "SubtitleTask"),
    P("Project overview", "H1Task"),
    P("This project develops a configurable arithmetic logic unit (ALU), small RAM and ROM blocks, selected SystemVerilog RTL examples, and a directed verification environment. It organizes design, assertion, test planning, and documentation artifacts for review.", "BodyTask"),
    P("Implemented design scope", "H1Task"),
    P("The ALU supports addition, subtraction, multiplication, AND, OR, XOR, NOT, logical left/right shifts, and equality comparison. The default width is 8 bits; the parameterized testbench instantiates 8-, 16-, and 32-bit configurations. The 16 x 8 single-port RAM uses synchronous writes and asynchronous reads. The 16 x 8 ROM contains a fixed documented lookup table.", "BodyTask"),
    make_table([
        ["Selector", "Function", "Defined status"],
        ["0-2", "ADD, SUB, MUL", "Carry and overflow semantics documented"],
        ["3-6", "AND, OR, XOR, NOT", "Bitwise operations"],
        ["7-8", "SHL, SHR", "Logical shifts; amount from low selector-width bits of B"],
        ["9", "EQ", "One-bit equality result, zero extended"],
        ["A-F", "Reserved", "Deterministic zero result"],
    ], [0.9*inch, 1.55*inch, 4.1*inch]),
    Spacer(1, 8),
    P("SystemVerilog examples use logic, always_comb, always_ff, a packed enum FSM state, and parameterized vectors. Immediate assertion monitors check legal state encodings, counter bounds, reset behavior, and unknown ALU outputs. Concurrent SVA syntax is explained separately because support depends on the simulator.", "BodyTask"),
    PageBreak(),
    P("Verification approach", "H1Task"),
    P("The test plan combines directed and repeatable pseudo-random operation checks, boundary conditions, invalid ALU selector behavior, width-scalability examples, memory address coverage, write-inhibit behavior, and sequential reset/enable checks. A functional coverage plan defines operation, operand, flag, width, address, and reset bins without claiming structural code-coverage percentages. A separate black-box plan defines reset, phase sequence, phase duration, state validity, and output exclusivity scenarios for the Task 2 traffic-light controller.", "BodyTask"),
    make_table([
        ["Test group", "Coverage intent", "Testbench"],
        ["ALU directed/random", "15 directed plus 64 repeatable pseudo-random checks; flags, shifts, compare, invalid opcode", "tb_alu.sv"],
        ["Parameterized ALU", "8-, 16-, and 32-bit instantiations", "tb_parameterized_alu.sv"],
        ["RAM and ROM", "Write/read all 16 RAM words, disabled write, compare all 16 ROM values", "tb_memory.sv"],
        ["SystemVerilog blocks", "Sync/async reset, enable capture/hold, enum FSM, counter overflow and clock assertions", "tb_systemverilog.sv"],
        ["Task 2 controller", "Reset, phase timing, legal states, outputs, edge corner cases", "black-box plan in docs/verification_plan.md; not rerun here"],
    ], [1.25*inch, 3.6*inch, 1.7*inch]),
    Spacer(1, 8),
    P("Simulation runner", "H2Task"),
    P("Run <font name='Courier'>bash scripts/run_all.sh</font> from the project root. It compiles four testbench tops with Icarus Verilog in SystemVerilog mode and is configured to save transcript logs and VCD traces. GTKWave can inspect the generated traces. The project includes a waveform review guide and identifies the signals and boundary events to inspect.", "BodyTask"),
    P("Evidence and bug status", "H1Task"),
    P("All four testbench tops were run in Ubuntu/WSL with Icarus Verilog. The ALU bench passed 15 directed and 64 repeatable pseudo-random checks; the parameterized ALU passed at 8, 16, and 32 bits; the memory bench passed all 16 RAM write/read locations, write inhibit, and all 16 ROM words; the SystemVerilog bench passed reset, flip-flop capture, register enable/hold, enum FSM, counter overflow, and clock synchronization checks. Logs and VCD traces are saved under simulation/. Three genuine GTKWave screenshots are included for ALU, RAM/ROM, and reset/FSM/counter traces. Concise observations are in docs/waveform_analysis.md. No confirmed design bug has been observed.", "BodyTask"),
    PageBreak(),
    P("Repository and deliverable map", "H1Task"),
    make_table([
        ["Deliverable", "Location"],
        ["Verilog/SystemVerilog RTL", "rtl/"],
        ["Verification testbenches", "testbench/"],
        ["Assertion source", "assertions/design_assertions.sv"],
        ["Simulation logs / VCD", "simulation/results/ and simulation/vcd/ (generated after passing run)"],
        ["GTKWave screenshots", "waveforms/alu_waveform.png, memory_ram_rom.png, reset_fsm_counter.png"],
        ["ALU and memory block diagrams", "docs/diagrams/"],
        ["Verification plan and test case matrix", "docs/verification_plan.md and docs/test_case_matrix.md"],
        ["Functional coverage plan", "docs/coverage_plan.md"],
        ["Bug report", "docs/bug_report.md"],
        ["README and project report", "README.md and docs/task3_project_report.pdf"],
        ["Daily progress log", "progress_log/progress.md"],
    ], [2.15*inch, 4.4*inch]),
    Spacer(1, 10),
    P("Reproduction steps", "H1Task"),
    P("1. Install or activate Icarus Verilog with SystemVerilog support and VVP.\n2. From the repository root, run <font name='Courier'>bash scripts/run_all.sh</font>.\n3. Review the logs under <font name='Courier'>simulation/results/</font>.\n4. Open each VCD in GTKWave and compare it with the representative captures and notes in <font name='Courier'>waveforms/</font> and <font name='Courier'>docs/waveform_analysis.md</font>.", "BodyTask"),
    P("Status note", "H2Task"),
    P("The saved simulation logs report all four testbench tops passing. Three representative GTKWave views are included. Review the simulator transcripts for detailed checks and consult docs/waveform_analysis.md for the visible signals and scope limits.", "BodyTask"),
    PageBreak(),
    P("GTKWave evidence", "H1Task"),
    P("ALU inputs, operation selector, result, and flags across directed and repeatable pseudo-random vectors.", "BodyTask"),
    Image(str(ROOT / "waveforms" / "alu_waveform.png"), width=7.15*inch, height=4.02*inch),
    PageBreak(),
    P("GTKWave evidence: RAM and ROM", "H1Task"),
    P("Address, clock, write control, input data, and memory outputs across the simulated address sequence.", "BodyTask"),
    Image(str(ROOT / "waveforms" / "memory_ram_rom.png"), width=7.15*inch, height=4.02*inch),
    PageBreak(),
    P("GTKWave evidence: reset, FSM, and counter", "H1Task"),
    P("Reset and clock, counter progression, FSM state/next state, and traffic-light outputs.", "BodyTask"),
    Image(str(ROOT / "waveforms" / "reset_fsm_counter.png"), width=7.15*inch, height=4.02*inch),
]

doc = SimpleDocTemplate(str(OUT), pagesize=letter, rightMargin=0.62*inch,
                        leftMargin=0.62*inch, topMargin=0.62*inch,
                        bottomMargin=0.72*inch, title="Task 3 Project Report",
                        author="VLSI Design and Semiconductor Engineering Task 3")
doc.build(story, onFirstPage=draw_page, onLaterPages=draw_page)
print(OUT)
