# ADTC 2026 — Offline Maternal Post-Discharge Follow-Up Assistant

**Track:** Healthcare & Medical
**Author:** Chiamaka — Registered Nurse and Midwife; automation & integration developer
**Location context:** Jos, Plateau State, Nigeria

## Problem
After childbirth, women are discharged home, and the post-discharge follow-up
visit that should catch deadly complications often does not happen. The reason
is not negligence — it is scarcity. There are too few nurses, and the few who
are available are kept with the patients physically present in the facility
rather than travelling house to house through the community. The clinical
judgement needed to run a safe follow-up visit — evidence-based postpartum
danger signs and, critically, when to escalate — lives in the head of a trained
nurse. The community health worker, volunteer, or family member who is actually
near the mother does not carry that knowledge. People are harmed in that gap:
postpartum haemorrhage causes recorded maternal deaths after women have already
gone home, and the largely invisible harm of an unsupported mother sliding into
postpartum depression goes uncaught entirely.

Target user: a community health worker or trained volunteer conducting
post-discharge home visits in a low-connectivity setting. Internet here is
unreliable and frequently drops after rain — precisely when guidance is most
needed — so any tool that depends on the cloud is useless at the moment it
matters.

## What the system does
The assistant runs fully offline on a low-cost laptop with no GPU and no network.
It supports the worker through a postpartum home visit in two parts. First, it
guides a check of physical danger signs: postpartum haemorrhage, fever and signs
of infection (endometritis, mastitis, UTI), pre-eclampsia warning signs, and
breast and urinary complications. Second — the part a clinician would not omit
but a generic tool would — it guides a psychosocial support assessment: whether
the mother is supported at home, eating and sleeping, and whether she shows signs
of postpartum depression. Every assessment ends with a clear ESCALATE-NOW or
CONTINUE recommendation. The system is decision support and triage only; it does
not diagnose. This scope boundary is deliberate and reflects what is safe for a
non-clinical worker to use in the field.

## Design decisions
- **Base model:** Qwen2.5-3B-Instruct. Chosen for strong instruction-following
  and clinical reasoning at a parameter count that sits comfortably inside the
  7 GB RAM ceiling, leaving large efficiency headroom on the target hardware.
- **Quantization:** GGUF Q4_K_M, run through llama.cpp. Q4_K_M balances answer
  quality against memory footprint: it keeps peak RAM low while preserving the
  clinical coherence of generated postpartum danger-sign guidance, which was
  verified by inspecting real model output.
- **Alternatives considered:** higher-precision quantizations raised the memory
  footprint with little practical gain in answer quality for this task; smaller
  models reduced clinical reasoning quality. A larger 7B model at Q4 is under
  evaluation as a quality-vs-speed trade-off on faster reference hardware.
- **Safety framing:** decision support and triage only, never diagnosis — the
  real scope boundary a clinician sets for a field-level tool.

## Constraints that shaped the approach
- **Hardware:** developed and tested on an HP EliteBook x360 1030 G2
  (Intel Core i5-7300U, 8 GB RAM, integrated graphics) — deliberately older than
  the benchmark machine, making it a pessimistic test bench: performance on the
  standard evaluation laptop should exceed what was observed here.
- **Connectivity:** zero cloud dependency is a hard requirement, because the
  target environment loses internet exactly when the tool is needed.
- **Language:** the current submission operates in English; Hausa support on the
  core danger-sign and escalation flow is planned to extend reach to local
  health workers.

## Benchmarks (self-reported, development machine)
| Metric | Value |
|---|---|
| Machine | HP EliteBook x360 1030 G2, i5-7300U, 8 GB RAM |
| Generation speed | 4.94 tokens/sec |
| Prompt processing | ~7.0 tokens/sec |
| Peak RAM | 2855.75 MB (budget 7000 MB) |
| Thermal throttling | None observed (throttled: false) |

These are self-reported development numbers on older-than-standard hardware.
Official scores are measured by the ADTC profiler on the standard evaluation
machine.

## Author note
I am a Registered Nurse and Midwife. I worked in settings where post-discharge
follow-up failed for exactly the reasons described above — not because anyone
was careless, but because there were never enough hands, and the knowledge to do
a safe visit could not travel with the few people who had it. I built this so
that the judgement a nurse carries can reach the home visit that actually
happens, offline, where the network does not reach and the nurse cannot go.


## Why I built this — in my own words
I am a Registered Nurse and Midwife, and this work comes from a burden I have
carried for years. Women go through so much to bring forth life, and the truth
is that not all of them get adequate support afterward. Some mothers show the
tell-tale signs of postpartum depression and their own families do not see it,
because no one ever trained them to look. And I have watched a new mother die
after childbirth, leaving children behind. Since then I have not been able to
put down the weight of wanting to help women survive and recover after they
give birth.

As nurses, we wish we could walk with a woman through pregnancy, through birth,
and through everything after. But we cannot — we are too few, and we are doing
the best we can with the hands we have. That is the real situation. So the
question I kept asking is this: how can a nurse safely distill her brain, her
hands, and her evidence-based practice, and delegate the part that can be
delegated — the follow-up visit — to the trained community health workers who
are actually allowed to do it, so that fewer women fall through the gap?

This tool is my attempt at an answer. It is not meant to replace a nurse. It is
meant to let a nurse's judgement reach the home she cannot get to, so that a
mother is not left alone with signs no one around her can read.

## References
1. World Health Organization. *WHO recommendations on maternal and newborn care for a positive postnatal experience.* Geneva: World Health Organization; 2022. https://www.who.int/publications/i/item/9789240045989 — establishes the global standard for routine postnatal care, including scheduled postnatal contacts for facility- and community-based care.
2. World Health Organization. *Consolidated guidelines for the prevention, diagnosis and treatment of postpartum haemorrhage.* Geneva: World Health Organization; 2025. — postpartum haemorrhage accounts for nearly one fifth of all maternal deaths, and is the leading cause of maternal mortality in most low-income countries.
3. World Health Organization. *Guide for integration of perinatal mental health in maternal and child health services.* Geneva: World Health Organization; 2022. https://www.who.int/publications/i/item/9789240057142 — supports identifying symptoms of perinatal mental health conditions and responding within maternal and child health services, adapted to local and cultural context.
