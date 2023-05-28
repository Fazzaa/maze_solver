import openpyxl
import string

# Qualche piccola info per l'utilizzo:
''' Per la creazione di una nuova mappa:
    - aggiungere al file excel: maze.xlsx un nuovo documento e chiamarlo DIMENSIONExDIMENSIONE
    - per indicare le caselle occupate: O (lettera o maiuscola);
    - per indicare stati finali: F
    - per indicare stato iniziale: S
    - **la mappa deve partire dalla riga 2 e dalla colonna B**
'''
# Per inserire la grandezza della mappa basta un numero (<= 25)
# Verrà creato un file chiamato dominio_DIMENSIONExDIMENSIONE 
# l'unica accortezza, rimuovere gli apici per lo stato finale.

N_MAP = int(input("Inserire grandezza mappa: "))
alphabet = list(string.ascii_uppercase)[1:]


workbook = openpyxl.Workbook()
workbook = openpyxl.load_workbook(filename = 'maze.xlsx')
sheet = workbook[f"{N_MAP}x{N_MAP}"]

f = open(f"dominio_{N_MAP}x{N_MAP}.pl", "w")
final_state = []
for row in range(2, N_MAP+2):
    for letter in alphabet:
        if sheet[f'{letter}{row-1}'].value == 'O':
            f.write(f"occupata(pos({row-1}, {alphabet.index(letter)+1})).\n")
        if sheet[f'{letter}{row}'].value == 'F':
            final_state.append(f"pos({row-1}, {alphabet.index(letter)+1})")
        if sheet[f'{letter}{row}'].value == 'S':
            f.write(f"iniziale(pos({row-1}, {alphabet.index(letter)+1})).\n") 

f.write(f"finale({final_state}).")
f.close()