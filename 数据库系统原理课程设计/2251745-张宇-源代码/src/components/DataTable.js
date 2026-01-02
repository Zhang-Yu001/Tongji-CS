import React from "react";

export default function DataTable({ data, onUpdate, onDelete, onAdd }) {
  const [newData, setNewData] = React.useState({ name: "", value: "" });

  return (
    <div>
      <h3>Database Data</h3>
      <table border="1" style={{ width: "100%" }}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Value</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {data.map((item) => (
            <tr key={item.id}>
              <td>{item.id}</td>
              <td>{item.name}</td>
              <td>
                <input
                  type="text"
                  value={item.value}
                  onChange={(e) => onUpdate(item.id, e.target.value)}
                />
              </td>
              <td>
                <button onClick={() => onDelete(item.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <div>
        <h4>Add New Data</h4>
        <input
          type="text"
          placeholder="Name"
          value={newData.name}
          onChange={(e) =>
            setNewData({ ...newData, name: e.target.value })
          }
        />
        <input
          type="text"
          placeholder="Value"
          value={newData.value}
          onChange={(e) =>
            setNewData({ ...newData, value: e.target.value })
          }
        />
        <button
          onClick={() => {
            onAdd(newData);
            setNewData({ name: "", value: "" });
          }}
        >
          Add
        </button>
      </div>
    </div>
  );
}
