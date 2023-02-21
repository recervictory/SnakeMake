import dash
from dash import Dash, html, dcc
import pandas as pd
import plotly.express as px

# Load the DESeq2 data
data = pd.read_csv('DESeq2_results.txt', sep='\t')

# Create the volcano plot
fig = px.scatter(data, x='log2FoldChange', y='pvalue', 
                 color_discrete_sequence=['red', 'gray'])

app = Dash()

app.layout = html.Div([
    html.H1('Volcano Plot of DESeq2 Results'),
    dcc.Graph(figure=fig)
])

if __name__ == '__main__':
    app.run_server(debug=True)
