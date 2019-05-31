#%%
import plotly.offline as py

"""
# Possible states: "AA", "BB", "CC", "EXIT"
0: "AA" - start with 10
1: "BB" - start with 20
2: "CC" - start with 30
Total: 60

# Step 1 
AA > AA: 5, AA > BB: 3, AA > CC: 2
BB > BB: 20
CC > AA: 20, CC > BB: 10
Balances: AA: 25, BB: 33, CC: 2
Extra index: 3: "AA", 4: "BB", 5: "CC"

# Step 2
AA > AA: 20, AA > BB: 4, AA > EXIT: 1
BB > AA: 15, BB > BB: 15, BB > EXIT: 3
CC > EXIT: 2
Extra index: 6: "AA", 7: "BB", 8: "EXIT"

"""

flows = dict(
    source=[0, 0, 0, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5],
    target=[3, 4, 5, 4, 3, 4, 6, 7, 8, 6, 7, 8, 8],
    value=[5, 3, 2, 20, 20, 10, 20, 4, 1, 15, 15, 3, 2],
)

data = dict(
    type="sankey",
    node=dict(
        pad=15,
        thickness=20,
        line=dict(color="black", width=0.5),
        label=["AA", "BB", "CC", "AA", "BB", "CC", "AA", "BB", "EXIT"],
        color=[
            "navy",
            "mediumblue",
            "royalblue",
            "navy",
            "mediumblue",
            "royalblue",
            "navy",
            "mediumblue",
            "crimson",
        ],
    ),
    link=flows,
)

layout = dict(title="Basic Sankey Diagram", font=dict(size=10))

fig = dict(data=[data], layout=layout)
py.iplot(fig, validate=False)


#%%
