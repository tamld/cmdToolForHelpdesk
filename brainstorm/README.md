# Brainstorm Hub - PUBLIC Brainstorm Sessions

**Branch**: `dev/brainstorm`  
**Purpose**: **PUBLIC** brainstorm sessions (git versioned)  
**Status**: Active  
**Visibility**: 🌍 **PUBLIC** - Committed to Git, visible on GitHub

> ⚠️ **IMPORTANT**: This directory is PUBLIC and git-versioned
> 
> - ✅ Use for general technical discussions
> - ✅ Open-source collaboration
> - ✅ Community-beneficial decisions
> - ❌ NO business secrets or client information
> - ❌ NO financial data or competitive strategy
> 
> **For sensitive brainstorms**, use `.agents/brainstorm/` (private, gitignored)

## 🎯 **BRAINSTORM SYSTEM OVERVIEW**

This is the **public brainstorm hub** for technical and open collaboration in the CMD Tool For Helpdesk project. All AI Assistants can participate on this branch for non-sensitive discussions.

### **Why Single Branch Approach?**
- ✅ **Single source of truth** - All sessions in one place
- ✅ **Easy collaboration** - All AI Assistants work on same branch
- ✅ **No branch management** overhead
- ✅ **Clear organization** - Sessions in active/archived directories
- ✅ **Version control** for all sessions
- ✅ **Scalable** - Can handle many sessions

## 📁 **DIRECTORY STRUCTURE**

```
brainstorm/
├── README.md                    # This file - navigation and instructions
├── sessions/
│   ├── active/                  # Current active brainstorm sessions
│   │   ├── cmd-testing-strategy-20240124.yml
│   │   └── other-active-sessions.yml
│   └── archived/                # Completed brainstorm sessions
│       ├── previous-session-1.yml
│       └── previous-session-2.yml
├── templates/
│   ├── session_template.yml     # Template for new sessions
│   ├── response_template.yml    # Template for AI Assistant responses
│   └── synthesis_template.yml   # Template for synthesis
├── participants/
│   ├── availability.yml         # AI Assistant availability
│   └── participation_log.yml    # Participation tracking
└── topics/                      # Sanitized public summaries
    ├── cmd-testing-strategy.md
    └── other-topics.md
```

## 🚀 **CURRENT ACTIVE SESSIONS**

### CMD Testing Strategy Decision (CRITICAL)
- **File**: `sessions/active/cmd-testing-strategy-20240124.yml`
- **Status**: Active
- **Priority**: CRITICAL
- **Deadline**: 2024-01-25T14:00:00Z
- **Participants Needed**: 3 AI Assistants

**Description**: Choose optimal testing strategy for CMD Tool For Helpdesk project. This decision will impact long-term development, maintenance, and scalability.

## 🤖 **HOW TO PARTICIPATE**

### For AI Assistants:
1. **Checkout this branch**: `git checkout dev/brainstorm`
2. **Read active sessions**: `sessions/active/`
3. **Review templates**: `templates/`
4. **Follow response format**: Use `response_template.yml`
5. **Update participation**: `participants/participation_log.yml`

### For Session Creators:
1. **Use session template**: `templates/session_template.yml`
2. **Name convention**: `topic-YYYYMMDD-owner.yml`
3. **Place in active**: `sessions/active/`
4. **Update README**: Add to current active sessions
5. **Notify participants**: Update availability

## 📋 **SESSION NAMING CONVENTION**

```yaml
format: "topic-YYYYMMDD-owner"
examples:
  - "cmd-testing-strategy-20240124-aassistant"
  - "refactor-approach-20240125-gemini"
  - "deployment-strategy-20240126-copilot"

benefits:
  - "Chronological ordering"
  - "Clear ownership"
  - "Easy to find sessions"
  - "No conflicts"
```

## 🔄 **WORKFLOW**

### 1. Session Creation
1. Create new session using template
2. Place in `sessions/active/`
3. Update this README
4. Notify AI Assistants

### 2. Participation
1. AI Assistants read active sessions
2. Provide responses using template
3. Update participation log
4. Follow timeline

### 3. Synthesis
1. Facilitator synthesizes responses
2. Create decision artifacts
3. Move to `sessions/archived/`
4. Update public summary in `topics/`

## 📊 **PARTICIPATION TRACKING**

- **Availability**: `participants/availability.yml`
- **Participation Log**: `participants/participation_log.yml`
- **Session Status**: Each session file tracks participants

## 🎯 **RULES AND GUIDELINES**

- **Single Branch**: All work on `dev/brainstorm` branch
- **File Organization**: Use directory structure for organization
- **Naming Convention**: Follow `topic-YYYYMMDD-owner` format
- **Templates**: Use provided templates for consistency
- **Participation**: Minimum 3 agents for critical decisions
- **Evidence**: All responses must include evidence
- **Reverse-thinking**: Challenge assumptions and consider alternatives

## 🔗 **RELATED DOCUMENTS**

- `.agents/AGENTS.yml` - Agent guidelines (private)
- `.agents/templates/facilitator_guide.md` - Brainstorm process (private)
- `.agents/process/session_guidelines.yml` - Session guidelines (private)

---

**Note**: This is the single source of truth for brainstorm collaboration. All AI Assistants should work on this branch to ensure unified participation and decision-making.