import dash
from dash import Dash, html, dcc
import pandas as pd
import plotly.express as px
import numpy as np

# Load the DESeq2 data
data = pd.read_csv('results/results_airway.tsv', sep='\t')
data['negative_padj'] = np.log10(data['padj']) * (-1)

# Create the volcano plot
fig = px.scatter(data, x='log2FoldChange', y='negative_padj', color='negative_padj',hover_name='symbol', size='negative_padj')
fig.update_layout(
    width=1600,
    height=800,)
app = Dash()

app.layout = html.Div([
    html.H1('Volcano Plot of DESeq2 Results'),
    dcc.Graph(figure=fig)
])

if __name__ == '__main__':
    app.run_server(debug=True)
