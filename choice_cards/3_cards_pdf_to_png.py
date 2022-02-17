## RUN THIS IN A PYTHON 3.0 TERMINAL
# pip install pdf2image
# pip install openpyxl
# python "C:\Users\bparthum\Box\farmland_conservation\analyze\farmland_git\choice_cards\3_cards_pdf_to_png.py"

from pdf2image import convert_from_path
import pandas as pd

## get data frame to reference
df = pd.read_excel(r'C:\Users\bparthum\Box\farmland_conservation\analyze\farmland_git\choice_cards\card_database.xlsx', sheet_name="Sheet1") # read xlsx as dataframe

## add blank rows in between each row in df to match blank pages from mail merge
def add_blank_rows(df, no_rows):
    df_new = pd.DataFrame(columns=df.columns)
    for idx in range(len(df)):
        df_new = df_new.append(df.iloc[idx])
        for _ in range(no_rows):
            df_new=df_new.append(pd.Series(), ignore_index=True)
    return df_new
df  = add_blank_rows(df, 1)

## get pages from pdf
pages = convert_from_path(r'C:\Users\bparthum\Box\farmland_conservation\analyze\farmland_git\choice_cards\cards_merged.pdf', dpi = 300, poppler_path=r'C:\Program Files\poppler-22.01.0\Library\bin')

# for i in range(len(pages)):
#     pages[i].save('C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\cards\\'+ str(df.treatment[i]) + '_block_' + str(df.block[i]) + '_card_' + str(df.card[i]) + '.png', 'PNG')

## subset pages then export as image using naming from referencing the underlying data df
for i in range(len(pages)):
    if (i/2).is_integer(): pages[i].save('C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\cards\\'+ str(df.treatment[i]) + '_block_' + str(df.block[i]) + '_card_' + str(df.card[i]) + '.png', 'PNG')
    else: pass