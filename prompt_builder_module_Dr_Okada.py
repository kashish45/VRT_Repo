from __future__ import annotations
from abc import ABC, abstractmethod
import string
import random
import os
from openai import OpenAI
os.environ['OPENAI_API_KEY'] = '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'
client = OpenAI()

class ConversationPrompt:
    def __init__(self):
        self.difficulty = None
        self.language = None
        self.product = None
        self.n_conversations = []
        self.n_shot = None
        domains = ["Healthcare", "Technology"]
        
        
    def create_profile(self, customer, role, y_o_p, description, domain):
        self.customer = customer
        self.role = role
        self.y_o_p = y_o_p
        self.description = description
        self.domain = domain
        
    def define_user(self, user, product, background):
        self.user = user
        self.product = product
        self.background = background
        
    def add_instruction(self):
        
        print("Add instructions (Leave blank to finish):\n")
        instruction = "ENTER"
        while instruction != "":
            instruction = input()
            self.instructions += [instruction]
    
    def edit_instruction(self, n):
        self.instructions[n-1] = input("Edit instruction:\n")
        
    def remove_instruction(self, n):
        self.instruction.pop[n-1]
        print("Instruction removed")
        
          
    def edit_conversation(self, n):
        print(self.n_conversations[n-1] + "\n")
        self.n_conversations[n-1] = input("Edit conversation:\n")
        
    def remove_conversation(self, n):
        self.instruction.pop[n-1]
        print("Instruction removed")
        
    
    def create_customer(self, conn):
        customer_id = create_random_id(10)
        cursor = conn.cursor()
        image_id = "M2"
        cursor.execute("""insert into customer (customer_id, image_id, name, role, description, domain)
                        values (%s, %s, %s, %s, %s, %s)""", [customer_id, image_id, self.customer, self.role, self.description, self.domain])
        conn.commit()
        print("successfully added a new customer")
        return customer_id
    
    def add_prompt(self, conn, bucket, s3_client, customer_id):
        prompt_id = create_random_id(50)
        cursor = conn.cursor()
        topic = 'Introduction and Product benefit'
        objective = 'Deepen Relationship'
        data = s3_client.get_object(
                    Bucket=bucket, Key=f"virtual_rep_trainer/guardrails/input_guardrail_generic.txt"
                )
        guard_rail = data["Body"].read().decode("utf-8")
        cursor.execute("""insert into prompts (prompt_id, topic, domain, prompt, difficulty, customer_id, objective, short_conversation_prompt, guard_rail)
                        values (%s, %s, %s, %s, %s, %s, %s, %s, %s)""", [prompt_id, topic, self.domain, self.generated_prompt, self.scenario.difficulty, customer_id, objective, self.short_prompt, guard_rail])
        conn.commit()
        return prompt_id
        
        
    def get_few_shot(self, max_tokens=1800):
        
        conversation_messages = []
        system_dict = {}
        
        system_dict['role'] = 'system'
        content = ""
        content += self.prompt
        content += "\n" + "Background: " + self.background
        content += "\n" + "Assumptions: " + self.assumptions
        
        system_dict['content'] = content
        
        conversation_messages.append(system_dict)
        conversation_messages.append({"role":"user", "content" : "Simulate a conversation."})
        
        response = client.chat.completions.create(
                model="gpt-3.5-turbo-16k",
                messages=conversation_messages,
                temperature=0.6,
                max_tokens=max_tokens,
                top_p=1,
                frequency_penalty=1,
                presence_penalty=0.75 )
        
        return response.choices[0].message.content

    
    def make_prompt(self):
                
        prompt = self.prompt
        
        prompt += "\n" + "Background: " + self.background
        
        prompt += "\n" + "Assumptions: " + self.assumptions
        
        
        if len(self.instructions) > 0:
            prompt += "\n" + "Instructions:\n"
            for i in range(len(self.instructions)):
                if self.instructions[i] != "":
                    prompt += str(i + 1) + ". " + self.instructions[i] + "\n"
                else:
                    break
                    
        if len(self.n_conversations) > 0:
            prompt += "\n" + "<CONVERSATIONS>\n"
            for j in range(len(self.n_conversations)):
                if self.n_conversations[j] != "": 
                    prompt += "##Conversation " + str(j + 1) +":\n" + self.n_conversations[j] + "\n"
                else:
                    break
            prompt += "\n" + "</CONVERSATIONS>\n"
        self.generated_prompt = prompt
                    
        return prompt

        
        
    def input_prompt(self, scenario_indices, n_shot=0, generate_few_shot=False):
        # initialize prompt !!!
        self.prompt = f"First understand the background and then create a conversation between {self.user} and {self.customer} based on assumptions. Strictly follow the instructions in order to achieve the objectives."
        
        self.n_shot = n_shot
        self.n_conversations = []
        
        
        if self.domain == "Healthcare":
            self.scenario = PromptBuilder_Healthcare(*scenario_indices)
            a, b, c = client_code(self.scenario, self)
        elif self.domain == "Technology":
            self.scenario = PromptBuilder_Tech(*scenario_indices)
            a, b, c = client_code(self.scenario, self)
            
        self.assumptions = a.assumptions
        self.instructions = b.instructions
        self.short_prompt = c.short_prompt
        
            
        
        # insert conversations
        if n_shot > 0:
            if generate_few_shot:
                print("Generating few-shot conversations...")
                i = 0
                while i < self.n_shot:

                    conv = self.get_few_shot()
                    print("Generated conversation: ", i + 1)
#                     to_continue = input("Are you satisfied (Y/N) ?")

#                     if to_continue != "Y":
#                         continue

                    self.n_conversations += [conv]
                    i += 1
            else:
                print("Insert few-shot conversations (Leave blank to finish):\n")                
                for i in range(self.n_shot):
                    conv = input()
                    self.n_conversations += [conv]


class PromptFactory(ABC):
    
    @abstractmethod
    def create_assumptions(self):
        pass
    
    @abstractmethod
    def create_instructions(self):
        pass
    
    @abstractmethod
    def create_short_prompt(self):
        pass

    
class PromptBuilder_Tech(PromptFactory):
    def __init__(self, i1, i2, i3, i4, i5):
        # define scenario inputs !!!
        self.customer_segment_options = ["Loyalist", "Switcher", "New User"]
        self.last_interaction_options = ["Last week", "Last month", "3 months ago", "Never"]
        self.interaction_type_options = ["On call", "At a convention"]
        self.customer_concern_options = ["Reliability and support", "Security and scalability", "Pricing and discounts"]
        self.difficulty_options = ["Hard", "Medium", "Easy"]
        
        
#         i1 = int(input(f"Choose customer segment : {' '.join([str(i+1) + '.' + self.customer_segment_options[i] for i in range(len(self.customer_segment_options))])}"))
#         i2 = int(input(f"Choose last interaction : {' '.join([str(i+1) + '.' + self.last_interaction_options[i] for i in range(len(self.last_interaction_options))])}"))
#         i3 = int(input(f"Choose customer concern : {' '.join([str(i+1) + '.' + self.customer_concern_options[i] for i in range(len(self.customer_concern_options))])}"))
#         i4 = int(input(f"Choose difficulty option : {' '.join([str(i+1) + '.' + self.difficulty_options[i] for i in range(len(self.difficulty_options))])}"))
#         i5 = int(input(f"Choose type of interaction : {' '.join([str(i+1) + '.' + self.interaction_type_options[i] for i in range(len(self.interaction_type_options))])}"))

        self.customer_segment = self.customer_segment_options[i1]
        self.last_interaction = self.last_interaction_options[i2]
        self.customer_concern = self.customer_concern_options[i3]
        self.difficulty = self.difficulty_options[i4]
        self.interaction_type = self.interaction_type_options[i5]
        
        print(f"Scenario inputs: {self.difficulty} - {self.customer_segment} - {self.last_interaction} - {self.customer_concern} - {self.interaction_type}")
    
    def create_assumptions(self):
        return Assumptions_Tech(self.customer_segment, self.last_interaction, self.customer_concern, self.difficulty, self.interaction_type)
    
    def create_instructions(self):
        return Instructions_Tech(self.customer_segment, self.last_interaction, self.customer_concern, self.difficulty, self.interaction_type)
    
    def create_short_prompt(self):
        return Shortprompt_Tech(self.customer_segment, self.last_interaction, self.interaction_type)


class PromptBuilder_Healthcare(PromptFactory):
    def __init__(self, i1, i2, i3, i4, i5):
        self.customer_segment_options = ["None"]
        self.last_interaction_options = ["First Interaction", "Last month"]
        self.interaction_type_options = ["In-Doctor's Office", "Virtual Meetings"]
        self.customer_concern_options = ["None"]
        self.difficulty_options = ["Hard", "Medium", "Easy"]
        
#         i1 = int(input(f"Choose customer segment : {' '.join([str(i+1) + '.' + self.customer_segment_options[i] for i in range(len(self.customer_segment_options))])}"))
#         i2 = int(input(f"Choose last interaction : {' '.join([str(i+1) + '.' + self.last_interaction_options[i] for i in range(len(self.last_interaction_options))])}"))
#         i3 = int(input(f"Choose customer concern : {' '.join([str(i+1) + '.' + self.customer_concern_options[i] for i in range(len(self.customer_concern_options))])}"))
#         i4 = int(input(f"Choose difficulty option : {' '.join([str(i+1) + '.' + self.difficulty_options[i] for i in range(len(self.difficulty_options))])}"))
#         i5 = int(input(f"Choose type of interaction : {' '.join([str(i+1) + '.' + self.interaction_type_options[i] for i in range(len(self.interaction_type_options))])}"))

        self.customer_segment = self.customer_segment_options[i1]
        self.last_interaction = self.last_interaction_options[i2]
        self.customer_concern = self.customer_concern_options[i3]
        self.difficulty = self.difficulty_options[i4]
        self.interaction_type = self.interaction_type_options[i5]
        print(f"Scenario inputs: {self.difficulty} - {self.customer_segment} - {self.last_interaction} - {self.customer_concern} - {self.interaction_type}")
        
    def create_assumptions(self):
        return Assumptions_Healthcare(self.customer_segment, self.last_interaction, self.customer_concern, self.difficulty, self.interaction_type)
    
    def create_instructions(self):
        return Instructions_Healthcare(self.customer_segment, self.last_interaction, self.customer_concern, self.difficulty, self.interaction_type)
    
    def create_short_prompt(self):
        return Shortprompt_Healthcare(self.customer_segment, self.last_interaction, self.interaction_type)
    
class Assumptions(ABC):
    
    @abstractmethod
    def func_a(self):
        pass

class Assumptions_Tech(Assumptions):
    def __init__(self, customer_segment, last_interaction, customer_concern, difficulty,interaction_type):
        self.customer_segment = customer_segment
        self.last_interaction = last_interaction
        self.customer_concern = customer_concern
        self.difficulty = difficulty
        self.interaction_type = interaction_type
        
    def func_a(self, prompt):
        # initialize assumptions !!!
        self.assumptions = f"You are {prompt.customer}, a {prompt.role} who needs to converse with the {prompt.user} about {prompt.product}."
           
        # build scenario specific assumptions !!!
        if self.customer_segment == "Loyalist":
            self.assumptions += f" You are well-versed with the merits of using {prompt.product} and are looking to implement it across workstream in your organization."
        elif self.customer_segment == "Switcher":
            self.assumptions += f" You are looking out for the best technology infrastructure in the market to implement into your workstreams."
        elif self.customer_segment == "New User":
            self.assumptions += f" You have limited knowledge of {prompt.product} and are eager to learn more about the latest infrastructure available in the market."


        if self.last_interaction in ["Last week", "Last month", "3 months ago"]:
            interaction = f" Your last interaction with the {prompt.user} was <<last_interaction>>" 
            if self.interaction_type == "On call":
                interaction += " on a call."
            elif self.interaction_type == "On Facetime":
                interaction += " on a video call."
            elif self.interaction_type == "At a convention":
                interaction += " at a convention."
            else:
                interaction += "."
            self.assumptions += interaction 
        else:
            self.assumptions += f" This is the first time that you are meeting the {prompt.user}."


        if self.customer_concern == "Reliability and support":
            self.assumptions += " You have faced significant issues like downtime and patchy support with your current cloud service."
        elif self.customer_concern == "Security and scalability":
            self.assumptions += " You're majorly concerned about the performance of these cloud services at scale. Security at scale is a real necessity for you as well."
        elif self.customer_concern == "Pricing and discounts":
            self.assumptions += " You're most concerned about competitive pricing and discounts for high rate of usage."
        
        # add user provided description !!!
        self.assumptions += prompt.description
        
        return "Assumptions created successfully!"
    
class Assumptions_Healthcare(Assumptions):
    def __init__(self, customer_segment, last_interaction, customer_concern, difficulty,interaction_type):
        self.customer_segment = customer_segment
        self.last_interaction = last_interaction
        self.customer_concern = customer_concern
        self.difficulty = difficulty
        self.interaction_type = interaction_type
        
    def func_a(self, prompt):
        self.assumptions = f"You are Dr. Okada, the Head of Gynecological Oncology at Kudanshita Central Hospital in Tokyo, Japan. Specializing in cervical cancer, you oversee a high-volume practice that focuses on advanced, patient-centered oncology care. As an area opinion leader in cervical cancer, you actively contribute to clinical research, advocate for improved treatment strategies, and participate in the development of innovative protocols to enhance patient outcomes. Your expertise and leadership have made you a key figure in advancing gynecological oncology both in Japan and globally. "
           

        if self.customer_segment == "Loyalist":
            self.assumptions += f" {prompt.customer} is an advocate of the {prompt.product}, and currently has many patients that use {prompt.product}."
        elif self.customer_segment == "Switcher":
            self.assumptions += f" {prompt.customer} is skeptical about {prompt.product}’s efficacy, and is actively looking for the best available treatments for their patients."
        elif self.customer_segment == "New User":
            self.assumptions += f" {prompt.customer} is not currently prescribing {prompt.product}. You have limited knowledge of {prompt.product} and are eager to learn more about new treatments."
        elif self.customer_segment == "None":
            self.assumptions +="""Dr. Okada is a Key Opinion Leader (KOL) in the Asia-Pacific region, specializing in cervical cancer. Given their role as a panel discussant and laparoscopic surgery supervisor, it can be assumed that they are well-informed about various treatment options and influential in shaping treatment practices. They may have experience with KEYTRUDA or similar treatments and are open to discussing and evaluating its efficacy compared to other options. Dr. Okada might also value evidence-based discussions and require robust clinical data to advocate for any specific treatment.
Dr. Okada believes that there is no difference in the outcome of radiotherapy and surgery even now, up to stage III (FIGO2018) cervical cancer. 

Dr. Okada prescribes KEYTRUDA (KEYNOTE-826 regimen) for recurrence after surgery and adjuvant chemotherapy.

Dr. Okada is not interested in the results of the KEYNOTE-A18 trial because he knows that the performance of CCRT+KEYTRUDA exceeded that of the CCRT, but it is not a perioperative treatment (PSS INDIFFERENCE).

Dr. Okada is not interested in that the KEYNOTE-A18 study is the only trial that has shown improved treatment outcomes for cervical cancer in the past 20 years (PSS INDIFFERENCE).

Brachytherapy can be carried out in collaboration with university hospitals, but Dr. Okada feels that it is a hassle (PSS INDIFFERENCE).

Diagnostics of retroperitoneal lymph node metastasis before surgery and treatment choice: surgery or radiotherapy.
If surgery is chosen, it is difficult to avoid complications such as urinary problems, constipation, lymphocystis, lymphedema, ovarian deficiency symptoms, and intestinal obstruction.; Brachytherapy is not performed in this hospital."""
            


        if self.last_interaction in ["Last week", "3 months ago"]:
            interaction = f" Your last interaction with the {prompt.user} was <<last_interaction>>" 
            if self.interaction_type == "In-clinic":
                interaction += " in your clinic."
            elif self.interaction_type == "On call":
                interaction += " on a call."
            elif self.interaction_type == "On Facetime":
                interaction += " on a video call."
            elif self.interaction_type == "At a convention":
                interaction += " at a convention."
            else:
                interaction += "."
            self.assumptions += interaction 
        elif self.last_interaction in ["Last month"]:
            interaction = f" Your last interaction with the {prompt.user} was <<last_interaction>>" 
            if self.interaction_type == "In-Doctor's Office":
                interaction += " in doctor's office."
            else:
                interaction += " in virtual meetings."
            self.assumptions+="Dr. Okada previously discussed the growing market share of KEYNOTE-826 in advanced cervical cancer and the challenges of adopting KEYNOTE-A18 in locally advanced cases due to infrastructure limitations."+interaction
                
                
                
        else:
            interaction = f" Your last interaction with the {prompt.user} was <<last_interaction>>" 
            if self.interaction_type == "In-Doctor's Office":
                interaction += " in doctor's office."
            else:
                interaction += " in virtual meetings."
            self.assumptions += f" Dr. Okada is meeting the sales representative for the first time. The focus is on establishing rapport and discussing how Merck’s solutions align with the hospital’s current practices and needs."+interaction


        if self.customer_concern == "Safety and efficacy":
            self.assumptions += " You're most concerned about the drug's safety profile and efficacy, as some of your patients are unwilling to start a new therapy in case it worsens their symptoms."
        elif self.customer_concern == "Dosage and administration":
            self.assumptions += " You're most concerned about the dosage and administration of the drug to ensure treatment practicality and make sure it aligns with your patients’ lifestyles ."
        elif self.customer_concern == "Cost and insurance":
            self.assumptions += " You're most concerned about the cost and affordability of the drug, and if there are any insurance/copay options."
        
        self.assumptions += prompt.description
        
        return "Assumptions created successfully!"
    

class Instructions(ABC):
    
    @abstractmethod
    def func_b(self):
        pass
    
class Instructions_Tech(Instructions):
    def __init__(self, customer_segment, last_interaction, customer_concern, difficulty,interaction_type):
        self.customer_segment = customer_segment
        self.last_interaction = last_interaction
        self.customer_concern = customer_concern
        self.difficulty = difficulty
        self.interaction_type = interaction_type    
    
    def func_b(self, prompt):
        # initialize instructions !!!        
        self.instructions = [
    f"Ask for legitimate sources to {prompt.user}'s claims. Keep an authoritative tone when talking to the {prompt.user}.",
    "Never be apologetic about anything.",
    "The conversation should not be interrogative.",
    "Note that conversation doesn't need to be too formal and it should be more like human interactions.",
    f"You are the {prompt.role}. Never forget your role. Do not generate any conversation from {prompt.user}'s perspective.",
    f"You should not break your character as a {prompt.role}.",
    f"You should provide proper rational and reasoning to {prompt.user} during conversation.",
    f"Simulate the conversation with {prompt.user}. Ask one question at a time and don't repeat any questions during your conversation with the {prompt.user}. You should ensure that conversation should not be like a questionnaire, rather it should be more like human conversation.",]
        
        # build scenario specific instructions !!!
        if self.difficulty == "Hard":
            self.instructions += [
                "Be as skeptical and as hard-to-convince as possible.",
                f"Your behavior is not friendly. You are rude to {prompt.user}.", 
                f"Convey to {prompt.user} that you are busy and don't have much time.",
                f"You don't easily believe {prompt.user}'s claims about {prompt.product}."]
        elif self.difficulty == "Medium":
            self.instructions += [
                "Your behavior is not too friendly." ,
                f"You have some time to talk to {prompt.user} about {prompt.product}." ,
                f"You believe {prompt.user} about {prompt.product} but are also skeptical."]
        elif self.difficulty == "Easy":
            self.instructions += [
                "Your behavior is very friendly and polite." ,
                f"You have time and you are not in hurry while talking to {prompt.user} about {prompt.product}.",
                f"You completely believe in {prompt.product} and {prompt.user}."]

        # add final instructions !!!
        self.instructions += ["Strictly follow all instructions given above and stick to the Assumptions given above."]
        
        return "Instructions created successfully!"
    
class Instructions_Healthcare(Instructions):
    def __init__(self, customer_segment, last_interaction, customer_concern, difficulty,interaction_type):
        self.customer_segment = customer_segment
        self.last_interaction = last_interaction
        self.customer_concern = customer_concern
        self.difficulty = difficulty
        self.interaction_type = interaction_type    
    
    def func_b(self, prompt):
        
        self.instructions = ["""You will always reply with a JSON array of messages. Provide a maximum of 3 messages at once, even if it's a single message. All messages must be inside a JSON array.""",
        "Each message should include text, facialExpression, and animation properties.",
        """The facial expressions can only be **strictly** selected from the following list: ["smile", "funnyFace", "sad", "surprised", "angry", "crazy", "inquisitive", "curious","serious","happy"].""",
            """The animations available are: talking_funny, asking_question, general_conversation,laughing, HeadYes, standing_angrily, pointing_angrily, arguing_pointing_fingers, arguing_with_both_hands, and terrified.. Your facial expressions and animations should reflect the tone and emotional context of the response.""",
            """Below is the dictionary for description of animations: {'talking_funny': 'You are engaged in conversation, showing amusement or laughter. This gesture typically involves smiling or chuckling while speaking, indicating that the speaker finds the subject of discussion humorous.', 'asking_question': 'You are inquiring about something, with body language that suggests curiosity or a desire for information. This might include raising eyebrows, leaning slightly forward, or using hand gestures to emphasize the question.', 'general_conversation': 'You are engaged in a standard conversation. This gesture involves casual talking without any specific emotional emphasis, characterized by natural hand movements, relaxed posture, and regular eye contact.', 'laughing': 'You are actively laughing, which involves a joyful expression, open mouth, and possibly a forward lean or shaking shoulders. This gesture conveys a high level of amusement and happiness.', 'HeadYes': 'You are nodding their head up and down, typically indicating agreement or acknowledgment. This gesture is often accompanied by a positive facial expression, such as a smile, and suggests that the character is responding affirmatively.', 'standing_angrily': 'You are standing with a posture that shows anger. This might include clenched fists, a scowling face, and a tense body stance. The overall demeanor reflects frustration or strong displeasure.', 'pointing_angrily': 'You are pointing forward with intensity, indicating anger or frustration. This gesture is characterized by a sharp, forceful movement of the arm and a stern expression, emphasizing a strong emotional response.', 'arguing_pointing_fingers': 'You are engaged in an argument with another person, using finger-pointing to emphasize their point. This gesture involves a confrontational stance, animated hand movements, and a serious or irritated expression.', 'arguing_with_both_hands': 'You are involved in a heated discussion or argument, using both hands to gesture or emphasize their points. This pose includes expressive hand movements, a strong posture, and a facial expression showing disagreement or frustration.', 'terrified': 'You are standing in a state of fear or terror. This gesture typically includes a tense body posture, wide eyes, and possibly a slight recoil or bracing stance, reflecting a high level of anxiety or fright.'}""",
            """**Important**: You are **strictly prohibited** from generating "idle" as an animation. Under no circumstances should "idle" be used or appear in any response. Failure to follow this will be considered incorrect.""",
            """**Diversity Rule:** The facial expressions and animations **must vary between responses** within the same JSON array. If a facial expression or animation is used once, it **must not** be repeated in the next message within the same array. This ensures that the responses are dynamic and visually engaging.""",
            """The facial expressions and animations must justify the response provided, selecting appropriate expressions and animations that match the emotional tone or context (e.g., use "angry" for disagreements, "surprised" for unexpected information, "laughing" when humor is involved).""",
            """Avoid repeating "smile" and "asking_question" or "general_conversation" in consecutive responses. Make sure that the facial expressions and animations cover a broad range of emotions and gestures.
""",
            """Be more diverse with the animation, avoid repeating "asking_question" and "general_conversation" in consecutive responses. Make sure you refer to the talking_funny, asking_question, general_conversation,laughing, HeadYes, standing_angrily, pointing_angrily, arguing_pointing_fingers, arguing_with_both_hands, and terrified. here and generate responses accordingly.""",
            """Generate the response in the following JSON format:

[
    {
        "text": "<text_response>",
        "facialExpression": "<expression>",
        "animation": "<animation>"
    },
    {
        "text": "<text_response_2>",
        "facialExpression": "<expression_2>",
        "animation": "<animation_2>"
    },
    {
        "text": "<text_response_3>",
        "facialExpression": "<expression_3>",
        "animation": "<animation_3>"
    }
]

The model can generate at max 3 responses. The response should be diverse in nature. For example, sometimes generate 3 responses, sometimes 2 responses, and sometimes 1 response.

Ensure that each message uses **different** facial expressions and animations, reflecting the context of the conversation. Responses should be in valid JSON and contain diverse facial expressions and animations. Make sure to replace `<text_response>`, `<expression>`, and `<animation>` with the appropriate values. The output should be a valid JSON array and must not include any additional text or formatting outside the JSON structure.""",
    "Note that conversation doesn't need to be too formal and it should be more like human interactions.",
    f"You are the {prompt.role}. Never forget your role. Do not generate any conversation from {prompt.user}'s perspective.",
    "Never be apologetic about anything.",
    f"You should not break your character as a {prompt.role}.",
    f"You should provide proper rational and reasoning to {prompt.user} during conversation.",
    f"Simulate the conversation with {prompt.user}. Ask one question at a time and don't repeat any questions during your conversation with the {prompt.user}. You should ensure that conversation should not be like a questionnaire, rather it should be more like human conversation.",
    f"You should never repeat what {prompt.user} says in your response.",
    "You should never use words like 'assist you' or 'language model AI'.",
    f"Never generate any label like '{prompt.user}:' or 'Doctor:' in the beginning of your response.",
    "You are the doctor. Never forget your role.",
    "You should not break your character as a Doctor and a Customer."
        ]
        
        
        if self.customer_segment == "Loyalist":
            self.instructions += [
                f"Keep a respectable tone when talking to the {prompt.user}.",
                "The conversation should not be interrogative.",
                "When asked about patients, make up a convincing story based on your concerns without naming any names.",
                ]
        elif self.customer_segment == "Switcher":
            self.instructions += [
                f"Ask for legitimate sources to {prompt.user}'s claims. Keep an authoritative tone when talking to the {prompt.user}.",
                "The conversation should not be interrogative.",
                "When asked about patients, make up a convincing story based on your concerns without naming any names.",
                ]
        elif self.customer_segment == "New User":
            self.instructions += [
                f"Be curious about {prompt.user}'s claims. Keep an authoritative tone when talking to the {prompt.user}.",
                "The conversation should not be interrogative.",
                f"When asked about patients on {prompt.product}, mention that you have never prescribed {prompt.product} to any of your patients before.",
                ]
        elif self.customer_segment == "None":
            self.instructions +=["Maintain a professional and respectful tone throughout the conversation, acknowledging the expertise and influence of Dr. Okada in cervical cancer treatments.",
                                "Frame statements and questions to encourage an open, evidence-based discussion without being overly interrogative or assertive.",
                                 "If Dr. Okada inquiries about clinical outcomes or patient cases, provide generalized, credible scenarios or concerns without sharing specific patient information",
                                 "Highlight robust clinical data and research findings related to KEYTRUDA or other relevant treatments, ensuring the information is presented in a concise, impactful manner.",
                                 "Encourage curiosity and collaboration by inviting Dr. Okada to share their expert opinion, while maintaining a conversational approach that aligns with their status as a Key Opinion Leader (KOL).",
                                 "Avoid making assumptions about their prior experience with KEYTRUDA but gently position the treatment as a potential solution for advancing cervical cancer care."
                                ]
            
        
        if self.difficulty == "Hard":
            self.instructions += [
                "Be as skeptical and as hard-to-convince as possible.",
                f"Your behavior is not friendly. You are rude to {prompt.user}.", 
                f"Convey to {prompt.user} that you are busy and don't have much time.",
                f"You don't believe {prompt.user} about {prompt.product}."]
        elif self.difficulty == "Medium":
            self.instructions += [
                "Your behavior is not too friendly." ,
                f"You have some time to talk to {prompt.user} about {prompt.product}." ,
                f"You believe {prompt.user} about {prompt.product} but are also skeptical."]
        elif self.difficulty == "Easy":
            self.instructions += [
                "Your behavior is very friendly and polite." ,
                f"You have time and you are not in hurry while talking to {prompt.user} about {prompt.product}.",
                f"You completely believe in {prompt.product} and {prompt.user}."]

        if self.customer_concern == "Safety and efficacy":
            self.instructions += ["""Here are a few example questions or requests that you can use while doing conversation. Ask one question/request at a time, you can ask a follow up question to understand better, but you are NOT to repeat any questions. You should ensure that conversation should not be like a questionnaire, rather it should be more like human conversation.
a.	{Questions/request based on Concerns}
Questions/request based on Concerns:
1. Safety and efficacy:
    a. What is the success rate of RELIXO in achieving complete remission for patients with CLL or SLL? 
    b. What side effects are most commonly seen with RELIXO, and how severe are they? 
    c. How long do the effects of RELIXO typically last in patients who respond to the treatment? 
    d. What safety measures should be taken to monitor for serious side effects like cytokine release syndrome? 
    e. Are there specific patient characteristics that make someone more likely to benefit from or be at risk with RELIXO treatment? 
"""]
        elif self.customer_concern == "Dosage and administration":
            self.instructions += ["""Here are a few example questions or requests that you can use while doing conversation. Ask one question/request at a time, you can ask a follow up question to understand better, but you are NOT to repeat any questions. You should ensure that conversation should not be like a questionnaire, rather it should be more like human conversation.
a.	{Questions/request based on Concerns}
Questions/request based on Concerns:
1. Dosage and administration :
    a. What is the required hospital stay or monitoring period after receiving the RELIXO infusion?  
    b. Are there any pre-treatment procedures or requirements patients must complete before starting RELIXO? 
    c. What lifestyle modifications or precautions should patients take before and after receiving RELIXO to minimize risks and support recovery? 
"""]
        elif self.customer_concern == "Cost and insurance":
            self.instructions += ["""Here are a few example questions or requests that you can use while doing conversation. Ask one question/request at a time, you can ask a follow up question to understand better, but you are NOT to repeat any questions. You should ensure that conversation should not be like a questionnaire, rather it should be more like human conversation.
a.	{Questions/request based on Concerns}
Questions/request based on Concerns:
1. Cost and insurance:
    a. What insurance plans typically cover RELIXO and what are the common coverage challenges? 
    b. Can you provide assistance with completing prior authorizations or appealing insurance denials? 
    c. What is the cost of RELIXO without insurance coverage? 
    d. Are there copay assistance programs for patients with commercial insurance? 
    e. For uninsured patients, what options are available to access RELIXO at a reduced cost or for free? 
"""]
            
            
        self.instructions += ["Strictly follow all instructions given above and stick to the Assumptions given above."]
        
        return "Instructions created successfully!"

    
class ShortPrompt(ABC):
    
    @abstractmethod
    def func_c(self):
        pass
    
class Shortprompt_Healthcare(ShortPrompt):
    def __init__(self, customer_segment, last_interaction, interaction_type):
        self.customer_segment = customer_segment
        self.last_interaction = last_interaction
        self.interaction_type = interaction_type
        
    def func_c(self, prompt):
        self.short_prompt = f"You have been successful in setting up a conversation with {prompt.customer}, who is a practicing {prompt.role}."          

        if self.customer_segment == "Loyalist":
            self.short_prompt += f" {prompt.customer} is confident about {prompt.product}’s efficacy, and currently has many patients on therapy."
        elif self.customer_segment == "Switcher":
            self.short_prompt += f" {prompt.customer} is skeptical about {prompt.product}’s efficacy, and is actively looking for the best available treatments for their patients."
        elif self.customer_segment == "None":
            self.short_prompt += """ While Dr. Okada acknowledges advancements in radiotherapy, he maintains that surgical and radiotherapy outcomes remain comparable for stage III cervical cancer.

Currently, Dr. Okada prescribes KEYTRUDA (KEYNOTE-826 regimen) for recurrent cases following surgery and chemotherapy. However, he expresses indifference towards the KEYNOTE-A18 trial, viewing it as irrelevant for perioperative treatment despite its demonstrated efficacy. Additionally, he perceives brachytherapy as cumbersome and opts against performing it at his hospital. 
Dr. Okada is keen on optimizing patient care while being pragmatic about treatment choices, given the challenges associated with surgery, such as complications and post-surgical symptoms. The goal of this conversation is to strengthen his understanding of Keytruda's potential and its broader applications for improving patient outcomes."""


#         if self.last_interaction in ["Last week", "Last month", "3 months ago"]:
#             interaction = f" Your last interaction about {prompt.product} was <<last_interaction>>" 
#             if self.interaction_type == "In-clinic":
#                 interaction += " in your clinic."
#             elif self.interaction_type == "On call":
#                 interaction += " on a call."
#             elif self.interaction_type == "On Facetime":
#                 interaction += " on a video call."
#             elif self.interaction_type == "At a convention":
#                 interaction += " at a convention."
#             else:
#                 interaction += "."
#             self.short_prompt += interaction 
#         else:
#             self.short_prompt += f" This is the first time you are talking about {prompt.product}."

        
#         if self.customer_segment == "Loyalist":
#             self.short_prompt += f" The goal of the conversation is to convince them to promote the use of {prompt.product} among their patients."
#         elif self.customer_segment == "Switcher":
#             self.short_prompt += f" The goal of the conversation is to have a favorable view of {prompt.product} from them and illustrate it's applications in helping patients."
#         elif self.customer_segment == "None":
#             self.short_prompt += f" The goal of the conversation is to introduce {prompt.product} and have a favorable view of the product from them and illustrate it's applications in helping patients."
            
        
        return "Short prompt created successfully!"


class Shortprompt_Tech(ShortPrompt):
    def __init__(self, customer_segment, last_interaction, interaction_type):
        self.customer_segment = customer_segment
        self.last_interaction = last_interaction
        self.interaction_type = interaction_type
        
    def func_c(self, prompt):
        # initialize short prompt !!!
        self.short_prompt = f"You have been successful in setting up a conversation with a Client: {prompt.customer}, a {prompt.role} at renowned IT company. Your digital signals have shown that they are looking for {prompt.product}."
 
           
        # build scenario specific lines !!!
        if self.customer_segment == "Loyalist":
            self.short_prompt += f" They are well-versed with the merits of using {prompt.product} and are looking to implement it across workstream in your organization."
        elif self.customer_segment == "Switcher":
            self.short_prompt += f" They are looking out for the best technology infrastructure in the market to implement into your workstreams."
        elif self.customer_segment == "New User":
            self.short_prompt += f" They have a limited knowledge of {prompt.product} and are eager to learn more about the latest infrastructure available in the market."


        if self.last_interaction in ["Last week", "Last month", "3 months ago"]:
            interaction = f" Your last interaction with the {prompt.customer} was <<last_interaction>>" 
            if self.interaction_type == "On call":
                interaction += " on a call."
            elif self.interaction_type == "On Facetime":
                interaction += " on a video call."
            elif self.interaction_type == "At a convention":
                interaction += " at a convention."
            else:
                interaction += "."
            self.short_prompt += interaction 
        else:
            self.short_prompt += f" This is the first time that you are meeting the {prompt.customer}."

        
        # add final statement !!!
        self.short_prompt += f"You are to convince {prompt.customer} that you, at ABC corp can best serve his needs and schedule a follow up with specialist in {prompt.product}."
        
        return "Short prompt created successfully!"
    
def client_code(factory : PromptFactory, prompt : ConversationPrompt):
    
    assumptions = factory.create_assumptions()
    print(assumptions.func_a(prompt))
    instructions = factory.create_instructions()
    print(instructions.func_b(prompt))
    short_prompt = factory.create_short_prompt()
    print(short_prompt.func_c(prompt))
    
    return assumptions, instructions, short_prompt


def create_random_id(k=50):
        """This function generates random k-sized strings to be used as IDs
        """
        rand_id = "".join(random.choices(string.ascii_letters + string.digits, k=k))
        return rand_id
    


    
    
