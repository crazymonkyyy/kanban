# AI Development Workflow

## Overview
This document outlines the standardized workflow for AI development work to ensure consistency, quality, and proper feedback loops.

## Workflow Phases

### 1. Planning Phase
1. **Requirement Analysis**
   - Fully understand the task requirements
   - Identify any ambiguities or unclear aspects
   - Ask clarifying questions if needed

2. **Research**
   - Study existing codebase and documentation
   - Understand relevant technologies and frameworks
   - Identify similar implementations or examples

3. **Design**
   - Create detailed implementation plan
   - Consider technical constraints and integration points
   - Plan for testing and validation
   - Document design decisions and rationale

4. **Documentation**
   - Create planning documents in `ai_thoughts` folder
   - Include detailed implementation approach
   - Document potential risks and mitigation strategies

### 2. Implementation Phase
1. **Setup**
   - Create feature branch for work
   - Set up development environment
   - Ensure all dependencies are available

2. **Development**
   - Follow implementation plan created in planning phase
   - Write clean, well-documented code
   - Adhere to existing code style and conventions
   - Test incrementally during development

3. **Testing**
   - Verify functionality works as expected
   - Test edge cases and error conditions
   - Ensure no regressions in existing functionality
   - Validate with actual code execution, not assumptions

### 3. Review Phase
1. **Self-Review**
   - Review all changes for quality and correctness
   - Ensure code follows project conventions
   - Verify all requirements have been met
   - Check for any potential issues or improvements

2. **Documentation Update**
   - Update relevant documentation
   - Ensure README and other docs are current
   - Add comments to code where appropriate

### 4. Pull Request Phase
1. **PR Preparation**
   - Create clear, descriptive commit messages
   - Write comprehensive PR description
   - Include testing instructions
   - Reference relevant issues or planning documents

2. **Submission**
   - Submit PR for review
   - Request review from appropriate team members
   - Address any feedback promptly and thoroughly

### 5. Clean Up Phase
1. **Post-Merge Cleanup**
   - Remove temporary files and debugging code
   - Archive planning documents to `ai_thoughts` folder
   - Update any relevant documentation
   - Close related issues or tasks

2. **Knowledge Transfer**
   - Document lessons learned
   - Share insights with team members
   - Update development guidelines if needed

## Feedback Loops

### Action Plans → Implementation
- Create detailed action plans before starting implementation
- Ensure action plans include clear success criteria
- Validate action plans with stakeholders before implementation

### Implementation → PR
- Create PRs that clearly show the work done
- Include comprehensive descriptions of changes
- Provide testing instructions for reviewers

### PR → Review
- Address all feedback thoroughly
- Make requested changes promptly
- Explain reasoning for any disagreements with evidence

### Review → Clean Up Passes
- Perform clean up passes after PR approval
- Remove any temporary code or debugging artifacts
- Archive planning documents and move final implementations

## Tools and Practices

### Documentation
- Store all planning documents in `ai_thoughts` folder
- Use markdown for all documentation
- Include clear headings and structure
- Document rationale for design decisions

### Version Control
- Use descriptive commit messages
- Follow conventional commit format when possible
- Create atomic commits for logical changes
- Use feature branches for all work

### Testing
- Always test with actual code execution
- Don't make assumptions about functionality
- Verify all claims with runnable code
- Test edge cases and error conditions

### Communication
- Be precise and factual in all communications
- When disagreeing, provide evidence through code execution
- Focus on technical accuracy over emotional responses
- Document all decisions and rationale clearly

## Quality Standards

### Code Quality
- Follow existing code style and conventions
- Write clean, readable, maintainable code
- Include appropriate comments and documentation
- Ensure proper error handling

### Documentation Quality
- Keep documentation up to date
- Write clear, concise, accurate documentation
- Include examples where appropriate
- Use consistent formatting and structure

### Review Quality
- Provide thorough, constructive feedback
- Focus on technical merits and requirements
- Avoid personal opinions or preferences
- Validate feedback with evidence when possible