## RUN THIS IN A PYTHON 3.0 TERMINAL
# py -m pip install pdf2image
# python "C:\Users\bparthum\Box\farmland_conservation\experiment_design\3_cards_pdf_to_png.py"

from pdf2image import convert_from_path
import pandas as pd

# export to png PILOT
df = pd.read_excel(r'C:\Users\bparthum\Box\farmland_conservation\analyze\farmland_git\choice_cards\card_database.xlsx', sheet_name="Sheet1") # read xlsx as dataframe
pages = convert_from_path(r'C:\Users\bparthum\Box\farmland_conservation\analyze\farmland_git\choice_cards\cards_merged.pdf', dpi = 300)

for i in range(len(pages)):
    pages[i].save('C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\cards\\'+ str(df.treatment[i]) + '_block_' + str(df.block[i]) + '_card_' + str(df.card[i]) + '.png', 'PNG')